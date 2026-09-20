#!/bin/sh
# Sway keybindings cheatsheet (rofi) - parses live config so it never goes stale.
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/sway/config.d"
grep -h '^[[:space:]]*bindsym' "$CONFIG_DIR"/*.conf 2>/dev/null \
  | sed -e 's/^[[:space:]]*bindsym[[:space:]]*//' \
    -e 's/\$mod/Super/g' -e 's/\$left/h/g' -e 's/\$down/j/g' \
    -e 's/\$up/k/g' -e 's/\$right/l/g' -e 's/\$term/ghostty/g' \
    -e 's/\$menu/app-launcher/g' \
  | sort -u \
  | awk '{ key=$1; $1=""; sub(/^ /, ""); printf "%-20s  │  %s\n", key, $0 }' \
  | rofi -dmenu -i -p 'Sway keys (type to filter)' -l 10 -theme ~/.config/rofi/keyhint.rasi
