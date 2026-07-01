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
CONTEXT_ANALYZER="
    def is_real_window:
        .type == \"con\" and (.window != null or .shell != null);

    def get_tiling_wins:
        [ recurse(.nodes[]?) | select(is_real_window) ];

    [
      .. | select(.type? == \"workspace\") |
      {ws: ., wins: get_tiling_wins} |
      select(.wins | any(.id == (\$id | tonumber)))
    ] | first |

    if . == null then \"error\" else
        (.wins | length) as \$count |
        (.wins | map(.id) | index(\$id | tonumber)) as \$idx |
        (.wins[1].id // \"none\") as \$target_id |
        \"\\(\$count) \\(\$idx) \\(\$target_id)\"
    end
"

# --- MAIN LOOP ---

swaymsg -t subscribe '["window"]' -m | jq --unbuffered -c "$EVENT_FILTER" | while read -r con_id; do
    # Process tree with the analyzer. Passing con_id as a JQ variable via --arg.
    result=$(swaymsg -t get_tree | jq -r --arg id "$con_id" "$CONTEXT_ANALYZER" 2>/dev/null)

    if [[ "$result" == "error" || -z "$result" ]]; then
        continue
    fi

    read -r count idx target_id <<< "$result"

    # Segment 3: Layout Actions
    # Use idx to ensure we only move windows that aren't already in the correct position.
    if (( count == 2 && idx == 1 )); then
        # Exactly two windows, and this is the second one: move it right to form the stack.
        swaymsg "[con_id=$con_id] move right; [con_id=$con_id] split vertical"
    elif (( count > 2 && idx > 1 )); then
        # More than two windows, and this one isn't the master (0) or the stack top (1).
        if [[ "$target_id" != "none" ]]; then
            mark="tmp_stack_$con_id"
            cmd="[con_id=$target_id] mark --add $mark; [con_id=$con_id] move container to mark $mark; [con_id=$target_id] unmark $mark; [con_id=$con_id] move up"
            swaymsg "$cmd"
        fi
    fi
done
