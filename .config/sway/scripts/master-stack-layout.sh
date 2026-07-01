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
swaymsg -t subscribe '["window"]' -m | jq --unbuffered -r '
    select(.change == "new" and .container.floating == "auto_off") | .container.id
' | while read -r con_id; do
    # Small delay to allow Sway to update its tree
    sleep 0.1

    # Get current workspace name
    ws=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused) | .name')
    [[ -z "$ws" ]] && continue

    # Extract tiling window IDs in this workspace
    tiling_ids=$(swaymsg -t get_tree | jq -r --arg ws "$ws" '
        .. | select(.type? == "workspace" and .name == $ws) |
        .. | select(.pid? and .floating == "auto_off") | .id
    ')

    count=$(echo "$tiling_ids" | grep -c .)

    # Case: Second window (Master + 1)
    if (( count == 2 )); then
        swaymsg "[con_id=$con_id] move right; [con_id=$con_id] focus; split vertical"
        continue
    fi

    # Case: Third and subsequent windows (Master + Stack)
    if (( count > 2 )); then
        # Identify target in the stack (skip master, exclude current, take last)
        target_id=$(echo "$tiling_ids" | grep -v "^$con_id$" | sed '1d' | tail -n 1)

        if [[ -n "$target_id" ]]; then
            swaymsg "[con_id=$target_id] mark tmp_stack; [con_id=$con_id] move container to mark tmp_stack; [con_id=$target_id] unmark tmp_stack"
        else
            swaymsg "[con_id=$con_id] move right"
        fi
    fi
done
