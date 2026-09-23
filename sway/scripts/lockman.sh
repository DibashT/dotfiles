#!/usr/bin/env sh
# Times the screen off and puts it to background
swayidle \
    timeout 300 'swaymsg "output * power off"' \
    resume 'swaymsg "output * power on"' &
IDLE_PID=$!
trap 'kill "$IDLE_PID" 2>/dev/null' INT TERM EXIT
# Locks the screen immediately
swaylock -c 000000
# Kills last background task so idle timer doesn't keep running
kill "$IDLE_PID" 2>/dev/null
