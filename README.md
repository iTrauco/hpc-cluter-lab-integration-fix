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

### Files
- `/etc/X11/xorg.conf` - Contains 30Hz hard limit
- `xbindkeys` - Installed at /usr/bin/xbindkeys