#!/bin/sh
# Night light control via wlsunset.
# Single source of truth for coords/temps: autostart, keybind, and
# Waybar all call this script. No runtime GeoIP lookup.
#
# wlsunset is sun-driven: left in its default mode it holds the screen at the
# high (neutral) temperature whenever the sun is up, so switching it on during
# the day changed nothing even though the process was running and the Waybar
# icon said "on". There is no flag to override that, but SIGUSR1 cycles the
# mode through
#     auto -> forced high -> forced low -> auto
# so `on` steps to forced low and the toggle works at any hour.
#
# wlsunset logs every mode change and every temperature it applies, so we keep
# that log and read the last temperature back out of it. That way `status`
# reports what is actually on screen instead of whether the process happens to
# be alive, which matters because in auto mode wlsunset runs all day long
# while deliberately keeping the screen neutral.

LAT="${WLSUNSET_LAT:-27.7}"
LON="${WLSUNSET_LON:-85.3}"
LOW="${WLSUNSET_LOW:-4000}"
HIGH="${WLSUNSET_HIGH:-6500}"
LOG="${WLSUNSET_LOG:-${XDG_RUNTIME_DIR:-/tmp}/night-light.log}"

# wlsunset answers a signal within a few milliseconds, so poll finely and keep
# the overall wait short: this runs on a button click.
POLL="${WLSUNSET_POLL:-0.02}"

signal_waybar() {
  pkill -RTMIN+7 waybar 2>/dev/null || true
}

pid() {
  pgrep -x wlsunset 2>/dev/null | head -1
}

# Temperature wlsunset last put on the screen; empty when unknown.
applied_temp() {
  sed -n 's/^setting temperature to \([0-9][0-9]*\) K$/\1/p' "$LOG" 2>/dev/null | tail -1
}

# "On" means a warm tint is really applied, which is not the same as wlsunset
# merely running: in auto mode it runs all day while holding the screen neutral.
is_warm() {
  [ -n "$(pid)" ] || return 1
  temp=$(applied_temp)
  case "$temp" in
    '' | *[!0-9]*) return 1 ;;
  esac
  [ "$temp" -lt "$HIGH" ]
}

spawn() {
  : >"$LOG"
  wlsunset -l "$LAT" -L "$LON" -t "$LOW" -T "$HIGH" >>"$LOG" 2>&1 &
}

# wlsunset publishes its first temperature a moment after start; wait for it so
# callers read real state instead of an empty log.
await_first_temp() {
  tries=0
  while [ "$tries" -lt 30 ]; do
    [ -n "$(applied_temp)" ] && return 0
    sleep "$POLL"
    tries=$((tries + 1))
  done
  return 1
}

# Wait until wlsunset has logged past the line count in $1, i.e. it has acted on
# a signal we sent. Returns 1 if it stays silent past the budget.
await_log_growth() {
  waits=0
  while [ "$waits" -lt 30 ]; do
    now=$(wc -l <"$LOG" 2>/dev/null || echo 0)
    [ "$now" -gt "$1" ] && return 0
    sleep "$POLL"
    waits=$((waits + 1))
  done
  return 1
}

# Step wlsunset to forced low. Reaching forced low from auto always passes
# through forced high, so signal one step at a time and check where we ended up
# after each. That lands correctly from any starting mode, and `cmd_on` only
# calls this while the screen is still neutral, so the forced high step is a
# visual no-op.
#
# Each step waits only for wlsunset to acknowledge the signal, not for the low
# marker specifically: the intermediate forced-high step never prints that
# marker, so waiting for it would idle out the whole budget and make the button
# feel broken.
force_low() {
  p=""
  tries=0
  while [ "$tries" -lt 30 ]; do
    p=$(pid)
    [ -n "$p" ] && break
    sleep "$POLL"
    tries=$((tries + 1))
  done
  [ -n "$p" ] || return 1

  tries=0
  while [ "$tries" -lt 3 ]; do
    mark=$(wc -l <"$LOG" 2>/dev/null || echo 0)
    kill -USR1 "$p" 2>/dev/null || return 1
    await_log_growth "$mark" || return 1
    if tail -n "+$((mark + 1))" "$LOG" 2>/dev/null |
      grep -q '^forcing low temperature$'; then
      return 0
    fi
    tries=$((tries + 1))
  done
  return 1
}

# Autostart: sun-driven, so the screen warms at dusk and clears at sunrise and
# stays neutral during the day.
cmd_start() {
  [ -n "$(pid)" ] && exit 0
  spawn
  await_first_temp
}

# Explicit request: warm the screen now, whatever the sun is doing.
cmd_on() {
  [ -n "$(pid)" ] || spawn
  await_first_temp
  # Already warm (auto mode after sunset). Leave the sun trajectory alone so
  # sunrise can still clear it, and so we skip the forced-high step.
  if is_warm; then
    return 0
  fi
  force_low
  signal_waybar
}

cmd_stop() {
  pkill -x wlsunset 2>/dev/null || true
  signal_waybar
}

# Flip whatever is on screen, rather than flipping the process: with autostart
# running, the process is usually up while the screen is still neutral.
cmd_toggle() {
  if is_warm; then
    cmd_stop
  else
    cmd_on
  fi
}

cmd_status() {
  if is_warm; then
    printf '{"text":" ","tooltip":"Night light on (%sK)","class":"on"}\n' "$(applied_temp)"
  else
    printf '{"text":" ","tooltip":"Night light off","class":"off"}\n'
  fi
}

case "${1:-start}" in
  start) cmd_start ;;
  stop | off) cmd_stop ;;
  on) cmd_on ;;
  toggle) cmd_toggle ;;
  status) cmd_status ;;
  *) echo "usage: $0 {start|stop|toggle|status|on|off}" >&2; exit 1 ;;
esac
