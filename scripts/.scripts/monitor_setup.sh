#!/usr/bin/env bash
# Switch fully to the external monitor when it's connected, back to the
# laptop panel when it's not. Triggered on hotplug via udev (see
# /etc/udev/rules.d/99-monitor-hotplug.rules) and safe to run by hand too.
set -euo pipefail

EXTERNAL=DP-1
INTERNAL=eDP-1

export DISPLAY="${DISPLAY:-:0}"
export XAUTHORITY="${XAUTHORITY:-/home/vlad/.Xauthority}"

if xrandr --query | grep -q "^${EXTERNAL} connected"; then
    xrandr --output "$EXTERNAL" --auto --primary --output "$INTERNAL" --off
else
    xrandr --output "$INTERNAL" --auto --primary --output "$EXTERNAL" --off
fi

sh /home/vlad/.fehbg
