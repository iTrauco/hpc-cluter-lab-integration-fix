# Display Commands Log

# Disable Dell Monitor 1 (Top Right)
xrandr --output DP-4 --off

# Re-enable Dell Monitor 1 with position
xrandr --output DP-4 --mode 3840x2160 --pos 3840x0

# Restore exact working configuration (Samsung at 1083, Dells stacked)
xrandr --output DP-6 --mode 3840x2160 --pos 0x1083 --output DP-4 --mode 3840x2160 --pos 3840x0 --output DP-2 --mode 3840x2160 --pos 3840x2160