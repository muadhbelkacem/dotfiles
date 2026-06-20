#!/bin/bash

# Function to get current volume percentage
get_volume() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2 * 100}' | cut -d. -f1
}

# Function to check if muted
is_muted() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "\[MUTED\]"
}

case $1 in
    up)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ --limit 1.0
        ;;
    down)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        ;;
    mute)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        ;;
esac

VOLUME=$(get_volume)

if is_muted; then
    notify-send -h string:x-canonical-private-synchronous:volume \
        -u low -i audio-volume-muted \
        "Volume" "Muted" -h int:value:0 -t 1000
else
    ICON="audio-volume-high"
    if [ "$VOLUME" -lt 33 ]; then
        ICON="audio-volume-low"
    elif [ "$VOLUME" -lt 66 ]; then
        ICON="audio-volume-medium"
    fi

    notify-send -h string:x-canonical-private-synchronous:volume \
        -u low -i "$ICON" \
        "Volume" "${VOLUME}%" -h "int:value:${VOLUME}" -t 1000
fi
