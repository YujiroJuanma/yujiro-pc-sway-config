#!/usr/bin/env bash
#
# i3-slide-ws.sh
#
# Simulates a workspace slide animation in i3wm by rapidly moving
# containers just before and after the workspace switch.
#
# Usage: Bind this script in your i3 config instead of the default 'workspace next/prev'.
# Example: bindsym $mod+Right exec --no-startup-id ~/path/to/i3-slide-ws.sh next right
#
# Arguments:
# 1 (Target): 'next' or 'prev' (i3 workspace command)
# 2 (Direction): 'left' or 'right' (visual direction for the slide)

# --- Configuration ---
# Number of frames for the animation (higher = smoother but slower)
FRAMES=10
# Distance to move per frame (10% of screen width)
STEP_SIZE_PERCENT=10

# Get screen width (required for movement calculation)
SCREEN_WIDTH=$(xrandr --current | grep '*' | awk '{print $1}' | cut -d 'x' -f 1 | head -n 1)

if [ -z "$SCREEN_WIDTH" ]; then
    echo "Error: Could not determine screen width. Executing instant switch." >&2
    i3-msg workspace "$1"
    exit 1
fi

STEP_PIXELS=$(( (SCREEN_WIDTH * STEP_SIZE_PERCENT / 100) / FRAMES ))
MOVEMENT_TOTAL=$(( SCREEN_WIDTH * STEP_SIZE_PERCENT / 100 ))

# Calculate the final movement sign based on direction
if [ "$2" == "right" ]; then
    MOVE_SIGN="-" # Moving current off-screen left
elif [ "$2" == "left" ]; then
    MOVE_SIGN="+" # Moving current off-screen right
else
    echo "Error: Invalid direction '$2'. Must be 'left' or 'right'." >&2
    i3-msg workspace "$1"
    exit 1
fi

# --- Phase 1: Slide Current Workspace Off-Screen ---
# Note: This moves the focused window's container, which should be the whole workspace
# if all windows are grouped under a single container (common in floating/tiling modes).

for ((i=1; i<=FRAMES; i++)); do
    i3-msg 'move container to position '${MOVE_SIGN}${STEP_PIXELS}' 0'
done

# --- Phase 2: Instant Workspace Switch ---
i3-msg workspace "$1"

# --- Phase 3: Slide New Workspace Into View ---
# The new workspace is now visible, but its windows are offset due to the movement above.
# We reverse the movement to bring the windows back to their default position.
# To ensure the new windows are visible immediately, we reset them slightly faster
# or simply move them back to 0 0.

# For a slide-in effect, we first position the new workspace off-screen...
i3-msg 'move container to position '$(( MOVEMENT_TOTAL * -1 ))' 0'

# ...then slide it into the center.
# The direction logic for the slide-in is tricky. We'll stick to a simple reset for stability.
# A full reverse loop is too slow and complex. A simpler reset or a single large move is better.

# Reset the new workspace's position (move it back the total distance it was offset)
if [ "$2" == "right" ]; then
    # Was offset left, move right
    i3-msg 'move container to position '$(( SCREEN_WIDTH ))' 0'
elif [ "$2" == "left" ]; then
    # Was offset right, move left
    i3-msg 'move container to position '$(( -1 * SCREEN_WIDTH ))' 0'
fi

# Now slide it into place
if [ "$2" == "right" ]; then
    MOVE_SIGN="-" # Move right back to 0
elif [ "$2" == "left" ]; then
    MOVE_SIGN="+" # Move left back to 0
fi

for ((i=1; i<=FRAMES; i++)); do
    i3-msg 'move container to position '${MOVE_SIGN}${STEP_PIXELS}' 0'
done

# Final check to ensure it's centered (optional, but good for robustness)
i3-msg 'move container to position 0 0'

exit 0

