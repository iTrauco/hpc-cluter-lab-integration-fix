# Homelab Critical Infrastructure Recovery

## Incident Summary
**Date**: September 2025  
**Impact**: Complete homelab infrastructure failure after HPC cluster expansion  
**Root Cause**: Display subsystem failure cascading to workstation control node  

## System Architecture (Pre-Incident)

### Master Control Node
- **Dell T5820 Tower Workstation**: Infrastructure management hub
  - Controls downstream HPC towers
  - Manages home network infrastructure
  - Runs critical services and automation
  - Display-dependent for all administrative access

### HPC Tower Nodes
- **Tower 1 (Primary)**: Lenovo ThinkStation P5
  - CPU: Intel Xeon W5-2445
  - RAM: 32GB ECC → Upgraded to 256GB ECC
  - GPU: NVIDIA RTX A5500
  
- **Tower 2 (New)**: Lenovo ThinkStation
  - CPU: Intel Xeon W3-2435  
  - RAM: 256GB ECC (removed during incident)
  - GPU: NVIDIA RTX A4000

### Storage Infrastructure
- **NAS**: 256TB WD Red Pro array
  - Status: OFFLINE (collateral damage from display system failure)
  - Critical data inaccessible

### Display Infrastructure
- 1x Samsung 4K TV/Monitor (Direct connection)
- 2x Dell 32" Curved Displays (HDMI switch routing)
- 5-way HDMI input switches for workspace flexibility

## Failure Cascade

### Initial Trigger
1. Added second HPC tower to existing setup
2. Performed infrastructure reorganization:
   - Replaced power distribution units
   - Rewired entire workstation setup
   - Migrated 256GB RAM from Tower 2 to Tower 1
   - Reconfigured display routing topology

### Cascade Effect
The display subsystem failure on the HPC towers created a critical single point of failure:
- Dell T5820 master control node manages downstream HPC towers
- Display failure on HPC towers prevented local access
- HPC towers became unmanageable from workstation
- 256TB NAS went offline - data inaccessible
- Home network services disrupted
- Internet connectivity compromised (routing controlled through master node)
- No alternate path to recover systems

## Recovery Process

### Phase 1: Isolation
- Disconnected all auxiliary systems
- Removed HDMI switches from signal path
- Connected single display directly to HPC tower
- Verified basic GPU functionality on Tower 2 (RTX A4000)

### Phase 2: Driver Stabilization
```bash
# Critical discovery: NVIDIA driver was fighting with display manager
# Driver: 580.65.06
# Issue: EDID data corruption after power cycling
```

### Phase 3: Display Configuration Management

Created systematic recovery tooling in `~/display-fix/`:

#### Reset Script Structure
```bash
#!/bin/bash
# Progressive display restoration
# Each step validated before proceeding

# Step 1: Auto-detect all displays
xrandr --auto

# Step 2: Verify connections
xrandr | grep " connected"

# Step 3: Force stable configuration
# [Configuration commands based on detected displays]
```

#### Hotkey Binding
- **Ctrl+Alt+D**: Emergency display reset
- Implemented via xbindkeys for instant recovery
- Prevents extended downtime during instability

### Phase 4: Systematic Restoration
1. Single display validation
2. Dual display extension (no mirroring)
3. Triple display configuration
4. HDMI switch reintegration
5. Full topology restoration

## Lessons Learned

### Critical Infrastructure Design Flaws
1. **Single Point of Failure**: Dell T5820 master control node governing both HPC towers AND home network
2. **No OOB Management**: Display failure on HPC towers = complete infrastructure lockout
3. **Cascading Dependencies**: Display → HPC Towers → Control Node → Network → Internet
4. **No Redundant Control Path**: All administration routes through Dell T5820 to downstream towers

### Implemented Mitigations
1. **Configuration Persistence**: Scripted display configurations
2. **Emergency Recovery**: Hotkey-triggered reset capability
3. **Progressive Validation**: Step-by-step restoration process
4. **State Documentation**: Capture working configurations

## Current Status
- Primary display: Functional (Samsung 4K @ 30Hz)
- Secondary displays: Stabilized (Dell 32" x2)
- HDMI switching: Pending validation
- Network control: Restored
- **NAS Storage**: 256TB array still OFFLINE - recovery pending

## Next Steps
1. Implement out-of-band management (IPMI/BMC) for all nodes
2. Deploy redundant control node or establish SSH-based headless access
3. Separate network management from display-dependent master control node
4. Create automated failover for critical services
5. Implement KVM over IP for emergency display-independent access
6. Document switch topology and cluster dependencies

## Technical Notes
- NVIDIA drivers aggressively cache EDID data
- Rapid input switching can corrupt DDC/CI communication
- Power cycling during active display negotiation causes persistent corruption
- Force composition pipeline can overload multi-display configurations

## Recovery Tools Location
All recovery scripts and configurations stored in:
```
~/display-fix/
├── reset-displays.sh       # Primary recovery script
├── baseline-config.txt     # Working configuration snapshot
└── logs/                   # Diagnostic outputs
```

---
*This incident highlighted the fragility of homelab infrastructure when display management becomes coupled with critical