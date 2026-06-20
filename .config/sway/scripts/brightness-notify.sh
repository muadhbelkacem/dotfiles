#!/bin/bash

# Function to get current brightness percentage
get_brightness() {
    brightnessctl -m | cut -d, -f4 | tr -d %
}

case $1 in
    up)
        brightnessctl set 5%+
        ;;
    down)
        brightnessctl set 5%-
        ;;
esac

BRIGHTNESS=$(get_brightness)

ICON="display-brightness"

notify-send -h string:x-canonical-private-synchronous:brightness \
    -u low -i "$ICON" \
    "Brightness" "${BRIGHTNESS}%" -h "int:value:${BRIGHTNESS}" -t 1000
