# HPC Tower 2 Configuration

## Branch: `feature/hpc-tower2-boot-restore`

## System Specifications
- **Hostname**: [TO BE FILLED]
- **Model**: Lenovo 30GA0013CA
- **CPU**: Intel Xeon W5-2445 (10 cores, 20 threads)
- **RAM**: 128GB (Passed Lenovo Diagnostics Memory Test)
- **GPU**: NVIDIA RTX A5500 (24GB VRAM)
- **Driver**: NVIDIA 550.163.01
- **OS**: Ubuntu 24.04.2 LTS
- **Kernel**: 6.14.0-29-generic

## Purpose
ML/AI compute node within home HPC/GPU cluster lab

## Display Configuration

### Current Status
- **DP-7**: Connected (3840x2160)
- **DP-0 through DP-6**: Disconnected

### Next Steps - Command & Control Workstation Integration
1. Power off Tower 2
2. Connect Samsung display to DP-6 (direct connection first, no switches)
3. Power on and verify 30Hz enforcement
4. If successful, integrate into HDMI switch matrix
5. Connect remaining displays (Dell monitors on DP-4 and DP-2)

### Display Control Commands

#### Samsung (DP-6) Control
```bash
# Enable Samsung on DP-6
xrandr --output DP-6 --mode 3840x2160 --rate 30

# Disable Samsung on DP-6
xrandr --output DP-6 --off

# Query DP-6 status
xrandr | grep "DP-6"
```

### 30Hz Hard Limit Configuration

```bash
# Create xorg.conf with hard 30Hz limit for ANY display that will ever connect
sudo bash -c 'cat > /etc/X11/xorg.conf << EOF
Section "Device"
    Identifier     "Device0"
    Driver         "nvidia"
    VendorName     "NVIDIA Corporation"
    Option         "ModeValidation" "MaxRefreshRate=30Hz"
EndSection
EOF'

# Restart display manager to apply
sudo systemctl restart lightdm
```

### Remove XFCE Display Override

```bash
# Backup and remove XFCE displays.xml that can override xorg.conf
mv ~/.config/xfce4/xfconf/xfce-perchannel-xml/displays.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/displays.xml.backup

# Clear nvidia-settings to prevent refresh rate override
echo "# Cleared to prevent refresh rate override" > ~/.nvidia-settings-rc

# Restart XFCE settings daemon
pkill xfsettingsd && sleep 1 && xfsettingsd --daemon
```

### Recovery Scripts Setup

```bash
# STEP 1: BACKUP EXISTING XBINDKEYS CONFIG
cp ~/.xbindkeysrc ~/.xbindkeysrc.backup.$(date +%Y%m%d_%H%M%S)
BACKUP_FILE=~/.xbindkeysrc.backup.$(date +%Y%m%d_%H%M%S)
echo "Backed up existing config to: $BACKUP_FILE"

# ROLLBACK COMMAND (if needed):
# cp $BACKUP_FILE ~/.xbindkeysrc && killall xbindkeys && xbindkeys

# STEP 2: Create display-fix directory
mkdir -p ~/display-fix

# STEP 3: Create reset-displays.sh script
cat > ~/display-fix/reset-displays.sh << 'EOF'
#!/bin/bash

# Check for reboot argument
if [[ "$1" == "reboot" ]]; then
    echo "=== EMERGENCY REBOOT ==="
    systemctl reboot
    exit 0
fi

# Check for extend argument
if [[ "$1" == "extend" ]]; then
    echo "=== APPLYING EXTENDED LAYOUT ==="
    xrandr --output DP-6 --mode 3840x2160 --rate 30 --pos 0x0 \
           --output DP-4 --mode 3840x2160 --rate 30 --pos 3840x0 \
           --output DP-2 --mode 3840x2160 --rate 30 --pos 3840x2160
    echo "=== EXTENDED LAYOUT APPLIED ==="
    exit 0
fi

# Check for reload-keys argument
if [[ "$1" == "reload-keys" ]]; then
    echo "=== RELOADING XBINDKEYS ==="
    killall xbindkeys
    xbindkeys
    echo "=== XBINDKEYS RELOADED ==="
    exit 0
fi

echo "=== EMERGENCY DISPLAY RESET ==="
echo "Running xrandr --auto to stabilize all displays..."

xrandr --auto

echo "Forcing all displays to mirror at 30Hz..."
for output in $(xrandr | grep " connected" | cut -d" " -f1); do
    xrandr --output $output --mode 3840x2160 --rate 30 --same-as DP-6 2>/dev/null || true
done

echo "=== RESET COMPLETE ==="
EOF

# Make script executable
chmod +x ~/display-fix/reset-displays.sh

# STEP 4: APPEND to xbindkeys configuration (not overwrite)
cat >> ~/.xbindkeysrc << 'EOF'

# Display recovery hotkeys
"~/display-fix/reset-displays.sh"
    Control+Alt+d
"~/display-fix/reset-displays.sh extend"
    Control+Alt+e
"~/display-fix/reset-displays.sh reboot"
    Control+Alt+r
"~/display-fix/reset-displays.sh reload-keys"
    Control+Alt+k
EOF

# STEP 5: Restart xbindkeys
killall xbindkeys 2>/dev/null || true
xbindkeys
```

### ROLLBACK IF NEEDED
```bash
# Find your backup file (will have timestamp)
ls -la ~/.xbindkeysrc.backup.*

# Restore from backup (replace TIMESTAMP with actual)
cp ~/.xbindkeysrc.backup.TIMESTAMP ~/.xbindkeysrc
killall xbindkeys
xbindkeys
```

### Hotkey Bindings
- **Ctrl+Alt+D**: Emergency reset (detect all displays and mirror at 30Hz)
- **Ctrl+Alt+E**: Extend displays (3-monitor layout)
- **Ctrl+Alt+R**: Emergency reboot
- **Ctrl+Alt+K**: Reload xbindkeys configuration

### Files
- `/etc/X11/xorg.conf` - Contains 30Hz hard limit
- `xbindkeys` - Installed at /usr/bin/xbindkeys
EOF'

# Restart display manager to apply


```bash

# 1. Create X11 config that overrides everything
sudo tee /etc/X11/xorg.conf.d/99-force-30hz-lock.conf << EOF
Section "Monitor"
    Identifier "DP-6"
    Option "DPMS" "false"
    Modeline "3840x2160_30" 297.00 3840 4016 4104 4400 2160 2168 2178 2250 +hsync +vsync
    Option "PreferredMode" "3840x2160_30"
EndSection

Section "Device"
    Identifier "nvidia"
    Driver "nvidia"
    Option "ModeValidation" "NoMaxPClkCheck"
    Option "ExactModeTimingsDVI" "true"
EndSection
EOF

# 2. Create watchdog service that enforces 30Hz
sudo tee /etc/systemd/system/force-30hz.service << EOF
[Unit]
Description=Force 30Hz refresh rate
After=graphical.target

[Service]
Type=simple
ExecStart=/bin/bash -c 'while true; do xrandr --output DP-6 --rate 29.97 2>/dev/null; sleep 5; done'
Restart=always
Environment=DISPLAY=:0

[Install]
WantedBy=graphical.target
EOF

sudo systemctl enable force-30hz.service
sudo systemctl start force-30hz.service

# 3. Lock nvidia-settings from saving configs
sudo chattr +i /etc/X11/xorg.conf 2>/dev/null
touch ~/.nvidia-settings-rc
sudo chattr +i ~/.nvidia-settings-rc
```
