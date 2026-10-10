#!/bin/sh
# Sway keybindings cheatsheet (rofi) - parses live config so it never goes stale.
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/sway/config.d"
grep -h '^[[:space:]]*bindsym' "$CONFIG_DIR"/*.conf 2>/dev/null \
  | sed -e 's/^[[:space:]]*bindsym[[:space:]]*//' \
    -e 's/\$mod/Super/g' -e 's/\$left/h/g' -e 's/\$down/j/g' \
    -e 's/\$up/k/g' -e 's/\$right/l/g' -e 's/\$term/ghostty/g' \
    -e 's/\$menu/app-launcher/g' -e 's/Shift+slash/?/g' \
    -e 's/Shift+\([a-z]\)\([^a-zA-Z]\|$\)/\U\1\2/g' -e 's/Shift+\([A-Z]\)\([^a-zA-Z]\|$\)/\1\2/g' \
  | sort -u \
  | awk '{ key=$1; $1=""; sub(/^ /, ""); pad = 18 - length(key); if (pad < 0) pad = 0; printf "<b>%s</b>%*s <span color=\"#F6C177\">:</span> %.80s\n", key, pad, "", substr($0, 1, 80) }' \
  | rofi -dmenu -i -markup-rows -p 'Sway keys (type to filter)' -l 7 -theme ~/.config/rofi/keyhint.rasi
