#!/bin/bash

# Kill other instances of this script to avoid duplicates on reload
for pid in $(pgrep -f "layout-notify.sh"); do
    if [ $pid != $$ ]; then
        kill $pid
    fi
done

# Listen for keyboard layout changes and send a notification
swaymsg -t subscribe '["input"]' -m | \
    jq --unbuffered -r 'select(.change == "xkb_layout") | .input.xkb_active_layout_name' | \
    stdbuf -oL uniq | \
    while read -r layout; do
        notify-send -h string:x-canonical-private-synchronous:layout "Keyboard Layout" "$layout" -t 1000
    done
