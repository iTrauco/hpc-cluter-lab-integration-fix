#!/bin/bash

# Check for reboot argument
if [[ "$1" == "reboot" ]]; then
    echo "=== EMERGENCY REBOOT ==="
    systemctl reboot
    exit 0
fi

# Check for extend argument
# if [[ "$1" == "extend" ]]; then
#     echo "=== APPLYING 3-MONITOR EXTENDED LAYOUT ==="
#     xrandr --output DP-6 --mode 3840x2160 --rate 30 --pos 0x982 \
#            --output DP-4 --mode 3840x2160 --rate 30 --pos 3864x0 \
#            --output DP-2 --mode 3840x2160 --rate 30 --pos 3840x2160
#     echo "=== EXTENDED LAYOUT APPLIED ==="
#     exit 0
# fi

if [[ "$1" == "extend" ]]; then
    echo "=== APPLYING 3-MONITOR EXTENDED LAYOUT ==="
    xrandr --output DP-6 --mode 3840x2160 --rate 30 --pos 0x982 \
           --output DP-4 --mode 3840x2160 --rate 30 --pos 3840x0 \
           --output DP-2 --mode 3840x2160 --rate 30 --pos 3840x2160
    echo "=== EXTENDED LAYOUT APPLIED ==="
    exit 0
fi

# Check for lock-rates argument
if [[ "$1" == "lock-rates" ]]; then
    echo "=== LOCKING RATES TO 30Hz AND SETTING POSITIONS ==="
    xrandr --output DP-6 --mode 3840x2160 --rate 30 --pos 0x982 \
           --output DP-4 --mode 3840x2160 --rate 30 --pos 3860x0 \
           --output DP-2 --mode 3840x2160 --rate 30 --pos 3840x2160
    echo "=== DISPLAYS POSITIONED AND LOCKED TO 30Hz ==="
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
xrandr --output DP-6 --mode 3840x2160 --rate 30 --same-as DP-4
xrandr --output DP-2 --mode 3840x2160 --rate 30 --same-as DP-4

echo "=== RESET COMPLETE ==="