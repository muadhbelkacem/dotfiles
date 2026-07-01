#!/bin/bash

# master-stack-layout.sh
# Implements a master-stack layout: one master window on the left,
# and all other windows in a vertical stack on the right.

# Ensure only one instance of this script runs
for pid in $(pgrep -f "${0##*/}"); do
    [[ "$pid" == "$$" ]] && continue
    kill "$pid" 2>/dev/null
done

# --- LOGIC SEGMENTS (JQ Filters) ---

# Segment 1: Event filter to identify new tiling windows
EVENT_FILTER="
    select(.change == \"new\"
           and .container.type == \"con\"
           and (.container.floating == \"auto_off\" or .container.floating == \"user_off\")
    ) | .container.id
"

# Segment 2: Tree analyzer to determine workspace context and window counts
# Using double quotes to satisfy SC2016, escaping JQ-internal variables.
CONTEXT_ANALYZER="
    def is_real_window:
        .type == \"con\" and .nodes == [] and (.window? or .window_properties? or .shell?);

    def get_tiling_wins:
        [ recurse(.nodes[]?) | select(is_real_window) ];

    [
      .. | select(.type? == \"workspace\") |
      {ws: ., wins: get_tiling_wins} |
      select(.wins | any(.id == (\$id | tonumber)))
    ] | first |

    if . == null then \"error\" else
        (.wins | length) as \$count |
        (.wins | map(select(.id != (\$id | tonumber))) | last | .id) as \$target_id |
        \"\\(\$count) \\(\$target_id // \"none\")\"
    end
"

# --- MAIN LOOP ---

swaymsg -t subscribe '["window"]' -m | jq --unbuffered -c "$EVENT_FILTER" | while read -r con_id; do
    # Fetch current tree for analysis
    tree=$(swaymsg -t get_tree)

    # Process tree with the analyzer. Passing con_id as a JQ variable via --arg.
    result=$(echo "$tree" | jq -r --arg id "$con_id" "$CONTEXT_ANALYZER" 2>/dev/null)

    if [[ "$result" == "error" || -z "$result" ]]; then
        continue
    fi

    read -r count target_id <<< "$result"

    # Segment 3: Layout Actions based on window count
    if (( count == 2 )); then
        # Second window: Move it to the right of the master and set up vertical splitting for the stack.
        swaymsg "[con_id=$con_id] move right; [con_id=$con_id] split vertical"
    elif (( count > 2 )); then
        # Third and subsequent windows: Move them into the existing vertical stack container at the top.
        if [[ "$target_id" != "none" ]]; then
            mark="tmp_stack_$con_id"
            # Batch the mark/move/unmark/move-up for atomicity
            cmd="[con_id=$target_id] mark --add $mark; [con_id=$con_id] move container to mark $mark; [con_id=$target_id] unmark $mark"
            # Move the new window to the top of the stack (count-2 moves up)
            for ((i=0; i < count - 2; i++)); do
                cmd="$cmd; [con_id=$con_id] move up"
            done
            swaymsg "$cmd"
        fi
    fi
done
