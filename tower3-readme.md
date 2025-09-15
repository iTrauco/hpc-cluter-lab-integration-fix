# HPC Tower 3 Configuration

## System Specifications
- **Hostname**: mad-scientist-w32435
- **Model**: Lenovo ThinkStation (Tower configuration)
- **CPU**: Intel Xeon W3-2435 (8 cores, 16 threads)
- **RAM**: 128GB ECC
- **GPU**: NVIDIA RTX A4000 (16GB VRAM)
- **Driver**: NVIDIA 580.65.06
- **OS**: Ubuntu 24.04.3 LTS
- **Kernel**: 6.11.0-1027-oem

## Purpose
ML/AI inference and training pipeline component within home HPC/GPU cluster lab

## Display Configuration

### Physical Setup
- **Monitor 1**: Samsung 55" TV/Monitor (1210mm x 680mm)
- **Monitor 2**: Dell 32" Curved 4K (697mm x 392mm) 
- **Monitor 3**: Dell 32" Curved 4K (697mm x 392mm)

### Connection Topology
All displays connected through 5-way HDMI switches:
```
Tower 3 (RTX A4000)
├── DP-6 → 5-way HDMI Switch → Samsung 55"
├── DP-4 → 5-way HDMI Switch → Dell 32" (Top)
└── DP-2 → 5-way HDMI Switch → Dell 32" (Bottom)
```

### Display Mapping
- **DPY-6 (DP-6)**: Samsung - Position 0,982 @ 30Hz
- **DPY-4 (DP-4)**: Dell Top Right - Position 3864,0 @ 30Hz  
- **DPY-2 (DP-2)**: Dell Bottom Right - Position 3840,2160 @ 30Hz

### Resolution
All displays: 3840x2160 (4K) @ 30Hz

## Critical Configuration Notes

### Refresh Rate Lock
All displays MUST be locked to 30Hz to prevent HDMI switch desynchronization when switching between HPC towers.

### NVIDIA MetaMode (Hardcoded)
```
DPY-6: 3840x2160_30 @3840x2160 +0+982
DPY-4: 3840x2160_30 @3840x2160 +3864+0  
DPY-2: 3840x2160_30 @3840x2160 +3840+2160
```

### Configuration Files
- `/etc/X11/xorg.conf` - Contains metamode configuration
- `~/.config/xfce4/xfconf/xfce-perchannel-xml/displays.xml` - DELETED to prevent override

## Recovery Scripts

### Location
`~/display-fix/`

### Hotkey Bindings
- **Ctrl+Alt+D**: Emergency reset (mirrors all displays)
- **Ctrl+Alt+E**: Extended layout (positions displays correctly)
- **Ctrl+Alt+R**: Emergency reboot
- **Ctrl+Alt+P**: Lock refresh rates to 30Hz and set positions
- **Ctrl+Alt+K**: Reload xbindkeys configuration

### Script Usage
```bash
~/display-fix/reset-displays.sh          # Mirror all displays
~/display-fix/reset-displays.sh extend   # Apply extended layout
~/display-fix/reset-displays.sh reboot   # Emergency reboot
~/display-fix/reset-displays.sh lock-rates  # Force 30Hz on all
```

## Known Issues & Solutions

### Issue: Displays go black when switching
**Cause**: Refresh rate mismatch between towers through HDMI switches
**Solution**: All displays locked to 30Hz in xorg.conf

### Issue: Samsung not detected
**Cause**: HDMI switch EDID passthrough failure
**Solution**: Power cycle switch, run `xrandr --auto`

### Issue: Display positions scrambled
**Solution**: Hit Ctrl+Alt+E or run extend script

## Switch Compatibility
When switching between towers, ensure other towers also output:
- 3840x2160 @ 30Hz on all displays
- Same port mapping (Samsung on DP-6, Dells on DP-4/DP-2)

## Boot Behavior
With `/etc/X11/xorg.conf` properly configured:
- All three displays auto-detect and position correctly on boot
- Samsung appears at position 0,982 on the left
- Dell monitors appear stacked on the right 
- All displays default to 30Hz refresh rate
- No manual intervention required after reboot