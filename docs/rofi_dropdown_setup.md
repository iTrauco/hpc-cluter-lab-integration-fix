# Script Browser Setup Guide

## Important Note on Display Toggles
Simple on/off toggle scripts for displays using xrandr state detection are unreliable. The display state doesn't always report correctly between on/off states. Instead, consider:
- Using state files to track toggle status
- System-wide display reset scripts  
- Scripts that reconfigure all active displays rather than individual toggles

## Overview
A rofi-based script browser that opens at mouse position with Ctrl+Alt+0, allowing quick navigation and execution of scripts.

## Dependencies

```bash
# Install rofi (dropdown menu)
sudo apt install rofi

# Install sxhkd (hotkey daemon)
sudo apt install sxhkd
```

## Setup

### 1. Create the Script Browser

```bash
# Create bin directory
mkdir -p ~/bin

# Create the script browser
echo '#!/bin/bash
current_dir="${1:-$HOME/scripts}"
items=$(echo "📁 .."; ls -la "$current_dir" | awk '\''NR>1 {if ($1 ~ /^d/) print "📁 " $NF; else if ($1 ~ /x/) print "⚙️ " $NF}'\'')
selection=$(echo "$items" | rofi -dmenu -i -p "Browse: $current_dir" -lines 15 -width 20 -location 0 -monitor -3 -theme-str "window {width: 400px;}")

if [ -n "$selection" ]; then
    name="${selection#* }"
    if [ "$name" = ".." ]; then
        exec "$0" "$(dirname "$current_dir")"
    else
        full_path="$current_dir/$name"
        if [ -d "$full_path" ]; then
            exec "$0" "$full_path"
        elif [ -x "$full_path" ]; then
            "$full_path"
        fi
    fi
fi' > ~/bin/script-browser

# Make executable
chmod +x ~/bin/script-browser

# Create scripts directory
mkdir -p ~/scripts
```

### 2. Configure Hotkey

```bash
# Create sxhkd config directory
mkdir -p ~/.config/sxhkd

# Add hotkey configuration
echo -e "ctrl + alt + 0\n    /home/$USER/bin/script-browser" > ~/.config/sxhkd/sxhkdrc

# Start sxhkd
sxhkd &

# Add to autostart (optional)
echo "sxhkd &" >> ~/.profile
```

## Usage

1. **Launch**: Press `Ctrl+Alt+0` anywhere
2. **Navigate**: 
   - Arrow keys to move through list
   - Type to filter items
   - Enter to select
   - Escape to cancel
3. **Icons**:
   - 📁 = Directory (enter to browse)
   - ⚙️ = Executable script (enter to run)
   - 📄 = Regular file (non-executable)

## Adding Scripts

Place executable scripts in `~/scripts/`:

```bash
# Example: Create a simple script
echo '#!/bin/bash
echo "Hello World"' > ~/scripts/hello.sh

# Make it executable
chmod +x ~/scripts/hello.sh
```

## Troubleshooting

### Hotkey not working
```bash
# Check if sxhkd is running
pgrep sxhkd

# Restart sxhkd
pkill sxhkd; sxhkd &

# Debug mode (shows errors)
pkill sxhkd; sxhkd
```

### Script browser not launching
```bash
# Test manually
~/bin/script-browser

# Check permissions
ls -la ~/bin/script-browser
chmod +x ~/bin/script-browser
```

### Rofi not found
```bash
# Verify installation
rofi -version

# Test rofi
echo -e "test1\ntest2" | rofi -dmenu
```

## Important Notes

### Display Toggle Scripts
Simple on/off toggle scripts for displays using xrandr state detection are unreliable. The display state doesn't always report correctly between on/off states. Instead, consider:
- Using state files to track toggle status
- System-wide display reset scripts
- Scripts that reconfigure all active displays rather than individual toggles

For display management, a full reconfiguration approach is more reliable:
```bash
# Example: Reset all displays
xrandr --auto  # Reset all to default
# Then apply your specific layout
```

## Customization

### Window appearance
Edit the rofi parameters in script-browser:
- `-lines 15` = Number of visible items
- `-width 20` = Width percentage (ignored with theme-str)
- `window {width: 400px;}` = Fixed pixel width

### Starting directory
Change default directory in script-browser:
```bash
current_dir="${1:-$HOME/scripts}"  # Change path here
```

### Different hotkey
Edit `~/.config/sxhkd/sxhkdrc`:
```bash
super + r  # Windows key + R
alt + space  # Alt + Space
ctrl + shift + s  # Ctrl+Shift+S
```

## Uninstall

```bash
# Stop sxhkd
pkill sxhkd

# Remove files
rm ~/bin/script-browser
rm ~/.config/sxhkd/sxhkdrc

# Remove from autostart
sed -i '/sxhkd &/d' ~/.profile
```