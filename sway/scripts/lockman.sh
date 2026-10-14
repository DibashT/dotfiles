#!/usr/bin/env sh
# Lock the screen immediately. Idle handling (screen off, suspend) is owned
# by the main swayidle policy in default-options-and-keymaps.conf, so this
# script deliberately starts no second daemon.
exec swaylock -f -c 000000
