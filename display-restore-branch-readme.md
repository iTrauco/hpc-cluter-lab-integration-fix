# HPC Tower 1 Display Restore Branch

## Branch: `feature/hpc-tower1-display-restore`

## Problem Statement
After adding a second HPC tower and reconfiguring the homelab infrastructure, the display subsystem on Tower 1 (Lenovo ThinkStation P5 with RTX A4000) became critically unstable. Monitors would:
- Randomly disconnect/reconnect
- Mirror when they should extend
- Go black without warning
- Become completely unusable, preventing terminal access

This created a cascade failure preventing management of the entire homelab infrastructure.

## Solution Approach

### Iterative Script Development
Instead of trying to fix everything at once, we developed a progressive restoration script that could be refined one step at a time.

### Core Discovery
`xrandr --auto` reliably returns the displays to a baseline functional state where:
- All connected monitors are detected
- Mirroring is applied (not ideal, but stable)
- System becomes usable again

### Emergency Recovery Implementation

#### 1. Script Location
```bash
~/display-fix/reset-displays.sh
```

#### 2. Script Content
```bash
#!/bin/bash

echo "=== EMERGENCY DISPLAY RESET ==="
echo "Running xrandr --auto to stabilize all displays..."

xrandr --auto

echo "=== RESET COMPLETE ==="
```

#### 3. Hotkey Binding
Using `xbindkeys` for instant recovery without needing visible terminal:

**~/.xbindkeysrc:**
```bash
"~/display-fix/reset-displays.sh"
    Control+Alt+d
```

#### 4. Activation
```bash
killall xbindkeys
xbindkeys
```

## Critical Design Decision
**Why a simple `xrandr --auto` instead of complex configuration?**

When displays are "tweaking out" (rapidly connecting/disconnecting), you need:
1. **Immediate stability** - not perfect configuration
2. **Blind execution** - works without seeing any monitor
3. **Guaranteed recovery** - simple command = less failure points
4. **Known good state** - even if mirrored, it's usable

## Usage

### When Displays Fail
1. Press `Ctrl+Alt+D`
2. Wait 2-3 seconds
3. Displays return to stable (mirrored) state
4. Can now access terminal to apply proper configuration

### Progressive Enhancement
Once stable baseline is achieved via hotkey:
```bash
# Step 1: Identify connected displays
xrandr | grep " connected"

# Step 2: Extend displays properly (example)
xrandr --output DP-6 --primary --mode 3840x2160 --pos 0x0 \
       --output DP-4 --mode 2560x1440 --pos 3840x0 \
       --output DP-2 --mode 2560x1440 --pos 6400x0
```

## Testing Protocol
1. Intentionally break display configuration
2. Monitors go black/unusable
3. Press `Ctrl+Alt+D` blind
4. Verify recovery to baseline state
5. Iterate script if needed

## Current Hardware Configuration
- **GPU**: NVIDIA RTX A4000 (Driver 580.65.06)
- **Monitor 1**: Samsung 4K TV/Monitor (DP-6)
- **Monitor 2**: Dell 32" Curved (DP-4)
- **Monitor 3**: Dell 32" Curved (DP-2)
- **Switching**: 5-way HDMI switches (currently bypassed for stability)

## Lessons Learned
1. **Start simple**: Complex xrandr commands fail during instability
2. **Blind recovery is critical**: Can't assume you can see terminal
3. **Hotkey binding essential**: GUI fails, mouse fails, but keyboard usually works
4. **Baseline > Perfect**: Stable mirrored beats black screens
5. **NVIDIA drivers cache bad state**: Fresh auto-detection clears issues

## Future Improvements
- [ ] Add logging to track failure patterns
- [ ] Create multiple recovery profiles (mirror vs extend)
- [ ] Implement automatic detection of "good" state
- [ ] Add network-triggered recovery option
- [ ] Create systemd service for boot-time stability

## Files in This Branch
```
~/display-fix/
├── README.md               # This file
├── reset-displays.sh       # Emergency recovery script
├── baseline-config.txt     # Last known good configuration
└── logs/                   # Diagnostic outputs (when accessible)
```

## Emergency Contact
If even Ctrl+Alt+D fails:
1. `Ctrl+Alt+F2` for TTY access
2. `sudo systemctl restart lightdm`
3. Physical power cycle as last resort

---
*Branch created during critical infrastructure recovery - September 2025*