#!/bin/sh
# Night light control via wlsunset.
# Single source of truth for the temperature: the Waybar module and the
# $mod+Shift+n keybind both call this script.
#
# Purely manual. The screen is normal until you switch the night light on and
# warm until you switch it off. There is no sun tracking and no automatic ramp.
#
# wlsunset is deliberately started without a latitude/longitude: with no
# location it reports "polar night" and simply holds the screen at the low
# temperature around the clock, which is exactly the always-on night light we
# want. Killing it makes sway reset the gamma ramp back to normal, so running
# and off are the same thing and no other state needs tracking.

LOW="${WLSUNSET_LOW:-4000}"

signal_waybar() {
  pkill -RTMIN+7 waybar 2>/dev/null || true
}

is_on() {
  pgrep -x wlsunset >/dev/null 2>&1
}

cmd_on() {
  is_on && return 0
  wlsunset -t "$LOW" >/dev/null 2>&1 &
  # Wait for it to register before refreshing the bar, otherwise the icon can
  # briefly redraw as "off" right after being switched on.
  tries=0
  while [ "$tries" -lt 30 ] && ! is_on; do
    sleep 0.02
    tries=$((tries + 1))
  done
  signal_waybar
}

cmd_off() {
  pkill -x wlsunset 2>/dev/null || true
  signal_waybar
}

cmd_toggle() {
  if is_on; then
    cmd_off
  else
    cmd_on
  fi
}

cmd_status() {
  if is_on; then
    printf '{"text":" ","tooltip":"Night light on (%sK)","class":"on"}\n' "$LOW"
  else
    printf '{"text":" ","tooltip":"Night light off","class":"off"}\n'
  fi
}

case "${1:-toggle}" in
  on) cmd_on ;;
  off | stop) cmd_off ;;
  toggle) cmd_toggle ;;
  status) cmd_status ;;
  *) echo "usage: $0 {on|off|toggle|status}" >&2; exit 1 ;;
esac
