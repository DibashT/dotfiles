#!/usr/bin/env sh
# Times the screen off and puts it to background
trap 'kill %1 2>/dev/null; exit' INT TERM EXIT
swayidle \
    timeout 300 'swaymsg "output * dpms off"' \
    resume 'swaymsg "output * dpms on"' &
# Locks the screen immediately
swaylock
# Kills last background task so idle timer doesn't keep running
kill %%
