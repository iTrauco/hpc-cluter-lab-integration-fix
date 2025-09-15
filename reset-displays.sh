#!/bin/bash

# Display reset script
echo "=== RESETTING DISPLAYS ==="

# STEP 1: Auto-detect all displays
echo "Step 1: Auto-detecting displays..."
xrandr --auto
sleep 2

# STEP 2: Check what's connected
echo "Step 2: Current connections:"
xrandr | grep " connected"

echo "=== RESET COMPLETE ==="
