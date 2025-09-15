# Check for reboot argument
if [[ "$1" == "reboot" ]]; then
    echo "=== EMERGENCY REBOOT ==="
    sudo reboot
    exit 0
fi

# 🚀 NEW SECTION STARTS HERE
# Check for extend argument
if [[ "$1" == "extend" ]]; then
    echo "=== APPLYING 3-MONITOR EXTENDED LAYOUT ==="
    xrandr --output DP-6 --mode 3840x2160 --pos 0x1121 \
           --output DP-4 --mode 3840x2160 --pos 3840x0 \
           --output DP-2 --mode 3840x2160 --pos 3840x2160
    echo "=== EXTENDED LAYOUT APPLIED ==="
    exit 0
fi
# 🚀 NEW SECTION ENDS HERE

echo "=== EMERGENCY DISPLAY RESET ==="
echo "Running xrandr --auto to stabilize all displays..."

xrandr --auto

echo "Forcing Samsung display on DP-6..."
xrandr --output DP-6 --mode 3840x2160 --rate 30

echo "=== RESET COMPLETE ==="