#!/bin/bash

# master-stack-layout.sh
# Implements a master-stack layout: one master window on the left,
# and all other windows in a vertical stack on the right.

# Kill other instances of this script to avoid duplicates
for pid in $(pgrep -f "${0##*/}"); do
    [[ "$pid" == "$$" ]] && continue
    kill "$pid" 2>/dev/null
done

# Subscribe to window events
stdbuf -oL swaymsg -t subscribe '["window"]' -m | while read -r line; do
    # Guard: Only react to 'new' window events
    [[ "$line" =~ \"change\"[[:space:]]*:[[:space:]]*\"new\" ]] || continue

    # Guard: Extract the container ID
    [[ "$line" =~ \"id\"[[:space:]]*:[[:space:]]*([0-9]+) ]] || continue
    con_id="${BASH_REMATCH[1]}"

    # Guard: Skip floating windows
    [[ "$line" =~ \"floating\"[[:space:]]*:[[:space:]]*\"(auto_on|user_on)\" ]] && continue

    # Small delay to allow Sway to update its tree
    sleep 0.1

    # Guard: Get current workspace name
    ws=$(swaymsg -t get_workspaces | grep -B 20 '"focused": true' | grep '"name":' | head -n 1 | cut -d '"' -f 4)
    [[ -z "$ws" ]] && continue

    # Extract tiling windows in this workspace
    tiling_nodes=$(swaymsg -t get_tree | sed -n "/\"name\": \"$ws\"/,/\"type\": \"workspace\"/p" | \
        tr -d '\n' | sed 's/},[[:space:]]*{/\n/g' | \
        grep '"floating":[[:space:]]*"auto_off"' | grep '"pid":')

    count=$(echo "$tiling_nodes" | grep -c .)

    # Case: Second window (Master + 1)
    (( count == 2 )) && {
        swaymsg "[con_id=$con_id] move right; [con_id=$con_id] focus; split vertical"
        continue
    }

    # Case: Third and subsequent windows (Master + Stack)
    (( count > 2 )) || continue

    target_id=$(echo "$tiling_nodes" | sed -n 's/.*"id":[[:space:]]*\([0-9]*\).*/\1/p' | \
        sed '1d' | grep -v "^$con_id$" | tail -n 1)

    [[ -z "$target_id" ]] && {
        swaymsg "[con_id=$con_id] move right"
        continue
    }

    swaymsg "[con_id=$target_id] mark tmp_stack; [con_id=$con_id] move container to mark tmp_stack; [con_id=$target_id] unmark tmp_stack"
done
