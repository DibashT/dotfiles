#!/bin/sh
# Night light control via wlsunset.
# Single source of truth for coords/temps: autostart, keybind, and
# Waybar all call this script. No runtime GeoIP lookup.
LAT="${WLSUNSET_LAT:-27.7}"
LON="${WLSUNSET_LON:-85.3}"
LOW="${WLSUNSET_LOW:-4000}"
HIGH="${WLSUNSET_HIGH:-6500}"

signal_waybar() {
  pkill -RTMIN+7 waybar 2>/dev/null || true
}

is_on() {
  pgrep -x wlsunset >/dev/null 2>&1
}

cmd_start() {
  if is_on; then
    exit 0
  fi
  exec wlsunset -l "$LAT" -L "$LON" -t "$LOW" -T "$HIGH"
}

cmd_stop() {
  pkill -x wlsunset 2>/dev/null || true
  signal_waybar
}

cmd_toggle() {
  if is_on; then
    pkill -x wlsunset 2>/dev/null || true
  else
    wlsunset -l "$LAT" -L "$LON" -t "$LOW" -T "$HIGH" >/dev/null 2>&1 &
  fi
  signal_waybar
}

cmd_status() {
  if is_on; then
    printf '{"text":"\ue32b ","tooltip":"Night light on (%sK)","class":"on"}\n' "$LOW"
  else
    printf '{"text":"\ue34c ","tooltip":"Night light off","class":"off"}\n'
  fi
}

case "${1:-start}" in
  start) cmd_start ;;
  stop) cmd_stop ;;
  toggle) cmd_toggle ;;
  status) cmd_status ;;
  on)
    if ! is_on; then
      wlsunset -l "$LAT" -L "$LON" -t "$LOW" -T "$HIGH" >/dev/null 2>&1 &
      signal_waybar
    fi
    ;;
  off) cmd_stop ;;
  *) echo "usage: $0 {start|stop|toggle|status|on|off}" >&2; exit 1 ;;
esac
