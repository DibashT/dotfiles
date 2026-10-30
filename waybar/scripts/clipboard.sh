#!/bin/sh
# Clipboard history picker (rofi) - formatted "id │ preview", paste via decode-by-id.
# Keeps full entry lookup working: rofi shows the formatted line, we decode by id.
selected=$(cliphist list | awk -F'\t' '{ gsub(/\t/, " ", $2); pad = 6 - length($1); if (pad < 0) pad = 0; printf "<b>%s</b>%*s <span color=\"#F6C177\">:</span> %.120s\n", $1, pad, "", $2 }' \
  | rofi -dmenu -i -markup-rows -theme ~/.config/rofi/clipboard.rasi -mesg 'Clipboard')
[ -z "$selected" ] && exit 0
id=$(printf '%s' "$selected" | awk -F':' '{ gsub(/<[^>]*>/, "", $1); gsub(/ /, "", $1); print $1 }')

# Preserve the stored MIME type instead of letting wl-copy guess. Images are
# copied only: Ctrl+Shift+V is a terminal shortcut and cannot paste images.
mime=$(cliphist decode "$id" | file --mime-type -b -)
case "$mime" in
  image/*)
    cliphist decode "$id" | wl-copy --type "$mime"
    ;;
  *)
    cliphist decode "$id" | wl-copy && wtype -M ctrl -M shift -k v -m ctrl -m shift
    ;;
esac
