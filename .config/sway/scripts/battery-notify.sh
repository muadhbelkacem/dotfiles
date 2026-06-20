#!/bin/bash

# Kill previous instances
pgrep -f "battery-notify.sh" | grep -v $$ | xargs -r kill

# Direct sysfs status function - the fastest way to read battery/AC state
get_status() {
    local online=0
    # Check all power supply online statuses (AC, USB-C, etc.)
    grep -q "1" /sys/class/power_supply/*/online 2>/dev/null && online=1

    local now=0
    local full=0
    # Aggregate data from all batteries
    for bat in /sys/class/power_supply/BAT*; do
        if [ -f "$bat/energy_now" ] && [ -f "$bat/energy_full" ]; then
            now=$((now + $(< "$bat/energy_now")))
            full=$((full + $(< "$bat/energy_full")))
        elif [ -f "$bat/charge_now" ] && [ -f "$bat/charge_full" ]; then
            now=$((now + $(< "$bat/charge_now")))
            full=$((full + $(< "$bat/charge_full")))
        fi
    done

    local percent=0
    [ $full -gt 0 ] && percent=$((now * 100 / full))
    echo "$percent $online"
}

# Initial state
read -r LAST_P LAST_O <<< "$(get_status)"

# udevadm monitor --kernel is the most immediate way to catch hardware changes.
# It bypasses the upower daemon's internal polling/filtering.
stdbuf -oL udevadm monitor --kernel --subsystem-match=power_supply | while read -r _; do
    # Poll current state immediately after a kernel event
    read -r P O <<< "$(get_status)"

    # Handle Plug/Unplug notifications
    if [ "$O" != "$LAST_O" ]; then
        if [ "$O" -eq 1 ]; then
            notify-send -h string:x-canonical-private-synchronous:battery \
                -u low -i "battery-charging" "Battery" "Charger Connected ($P%)" \
                -h "int:value:$P" -t 3000
        else
            notify-send -h string:x-canonical-private-synchronous:battery \
                -u low -i "battery-caution" "Battery" "Charger Disconnected ($P%)" \
                -h "int:value:$P" -t 3000
        fi
        LAST_O=$O
    fi

    # Low battery alerts (only when discharging)
    if [ "$O" -eq 0 ]; then
        if [ "$P" -le 10 ] && [ "$LAST_P" -gt 10 ]; then
            notify-send -h string:x-canonical-private-synchronous:battery \
                -u critical -i "battery-empty" "Battery Critical" "$P% remaining" \
                -h "int:value:$P"
        elif [ "$P" -le 20 ] && [ "$LAST_P" -gt 20 ]; then
            notify-send -h string:x-canonical-private-synchronous:battery \
                -u normal -i "battery-low" "Battery Low" "$P% remaining" \
                -h "int:value:$P"
        fi
    fi

    LAST_P=$P
done
