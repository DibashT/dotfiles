#!/usr/bin/env bash
set -euo pipefail

# Next-wallpaper switcher for sway.
# Uses swaymsg so sway manages swaybg itself (no killall).

BACKGROUND_DIR="$HOME/.config/backgrounds"
SWAY_CONFIG="$HOME/.config/sway/config"

# No pictures -> stop with message
shopt -s nullglob
BACKGROUND_LIST=("$BACKGROUND_DIR"/*)
shopt -u nullglob
if [[ ${#BACKGROUND_LIST[@]} -eq 0 ]]; then
    notify-send "Background changed" "No files in $BACKGROUND_DIR"
    exit 1
fi

# Read current wallpaper path from sway config:  output * bg <path> fill
CURRENT_FULL=$(sed -n 's|^output \* bg \(.*\) fill$|\1|p' "$SWAY_CONFIG" | head -n 1)

# Find where we are in the list (match by file name, safe with spaces)
CURRENT_BASE="$(basename "$CURRENT_FULL")"
CURRENT_INDEX=0
for i in "${!BACKGROUND_LIST[@]}"; do
    if [[ "$(basename "${BACKGROUND_LIST[$i]}")" == "$CURRENT_BASE" ]]; then
        CURRENT_INDEX=$i
        break
    fi
done

# Next file, back to start at the end
NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#BACKGROUND_LIST[@]} ))
NEXT_BACKGROUND="${BACKGROUND_LIST[$NEXT_INDEX]}"

# Show it now (sway takes care of swaybg)
swaymsg output '"*"' bg "$NEXT_BACKGROUND" fill >/dev/null

# Save it so restart keeps the same picture (& escaped for sed)
ESCAPED_NEXT="${NEXT_BACKGROUND//&/\\&}"
sed -i "s|^output \* bg.*|output * bg $ESCAPED_NEXT fill|" "$SWAY_CONFIG"

# Small popup with new name
notify-send -i "$NEXT_BACKGROUND" "Background changed" "$(basename "$NEXT_BACKGROUND")"
