#!/bin/bash

# Kill other instances of this script to avoid duplicates on reload
for pid in $(pgrep -f "${0##*/}"); do
    [[ "$pid" == "$$" ]] && continue
    kill "$pid" 2>/dev/null
done

# Target mark for the scratchpad terminal
TARGET_MARK="scratchpad_term"

# Track if the scratchpad was the last focused window (0/1)
was_focused=0

# Subscribe to window events using swaymsg
# Using stdbuf to ensure the output is processed line-by-line immediately
stdbuf -oL swaymsg -t subscribe '["window"]' -m | while read -r line; do
    # 1. Identify the event type (focus or close)
    [[ "$line" =~ \"change\"[[:space:]]*:[[:space:]]*\"(focus|close)\" ]] || continue
    event_type="${BASH_REMATCH[1]}"

    # 2. Guard: Handle state updates for the target scratchpad window
    [[ "$line" =~ \"marks\"[[:space:]]*:[[:space:]]*\[([^]]*)\] ]] || continue
    [[ "${BASH_REMATCH[1]}" == *\""$TARGET_MARK"\"* ]] && {
        [[ "$event_type" == "focus" ]] && was_focused=1
        [[ "$event_type" == "close" ]] && was_focused=0
        continue
    }

    # 3. Guard: Handle focus shifting away from the scratchpad to another window
    [[ "$event_type" == "focus" ]] || continue
    (( was_focused ))          || continue

    # Action: Focus was on scratchpad but moved to another window -> hide it
    swaymsg "[con_mark=\"$TARGET_MARK\"] move scratchpad" > /dev/null 2>&1
    was_focused=0
done
