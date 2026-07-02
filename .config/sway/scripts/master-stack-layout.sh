#!/bin/bash

# master-stack-layout.sh
# Implements a master-stack layout using a state machine:
# one master window on the left, and all other windows in a vertical stack on the right.

# Ensure only one instance of this script runs
for pid in $(pgrep -f "${0##*/}"); do
    [[ "$pid" == "$$" ]] && continue
    kill "$pid" 2>/dev/null
done

# --- LOGIC SEGMENTS (JQ Filters) ---

# Segment 1: Event filter to identify new and moved tiling windows
EVENT_FILTER="
    select((.change == \"new\" or .change == \"move\" or .change == \"focus\")
           and .container.type == \"con\"
           and (.container.floating == \"auto_off\" or .container.floating == \"user_off\")
    ) | .container.id
"

# Segment 2: State Analyzer
# Determines the current workspace topology and suggests a transition state.
STATE_ANALYZER="
    def is_real_window:
        .type == \"con\" and (.window != null or .shell != null);

    def get_tiling_wins:
        [ recurse(.nodes[]?) | select(is_real_window) ];

    [
      .. | select(.type? == \"workspace\") |
      {ws: ., wins: get_tiling_wins} |
      select(.wins | any(.id == (\$id | tonumber)))
    ] | first |

    if . == null then \"IGNORE\" else
        (.wins | length) as \$count |
        (.wins | map(.id) | index(\$id | tonumber)) as \$idx |
        (.wins[1].id // \"none\") as \$target_id |
        (.ws | recurse(.nodes[]?) | select(.nodes? | any(.id == (\$id | tonumber))) | .layout) as \$layout |
        (.wins[0].id) as \$first_id |
        (.ws | recurse(.nodes[]?) | select(.nodes? | any(.id == \$first_id)) | .layout) as \$first_layout |

        if \$count > 0 and \$first_layout == \"splitv\" then
            \"REPAIR_MASTER \\(\$first_id)\"
        elif \$count == 2 and \$idx == 1 and \$layout != \"splitv\" then
            \"INIT_STACK\"
        elif \$count > 2 and \$idx > 1 and \$layout != \"splitv\" then
            \"ADD_TO_STACK \\(\$target_id)\"
        else
            \"STABLE\"
        end
    end
"

# --- MAIN LOOP (State Machine Dispatcher) ---

swaymsg -t subscribe '["window"]' -m | jq --unbuffered -c "$EVENT_FILTER" | while read -r con_id; do
    # Analyze the tree and get the transition state
    result=$(swaymsg -t get_tree | jq -r --arg id "$con_id" "$STATE_ANALYZER" 2>/dev/null)

    # Dispatch based on the suggested state
    read -r state data <<< "$result"

    case "$state" in
        REPAIR_MASTER)
            # Master is missing or inside the stack; promote the first window.
            target_id="$data"
            swaymsg "[con_id=$target_id] move left"
            ;;

        INIT_STACK)
            # Two windows exist; move the new one right and initialize vertical split.
            swaymsg "[con_id=$con_id] move right; [con_id=$con_id] split vertical"
            ;;

        ADD_TO_STACK)
            # Three or more windows; move the new window to the existing stack top.
            target_id="$data"
            mark="tmp_stack_$con_id"
            swaymsg "[con_id=$target_id] mark --add $mark; [con_id=$con_id] move container to mark $mark; [con_id=$target_id] unmark $mark; [con_id=$con_id] move up"
            ;;

        STABLE | IGNORE)
            # Layout is already correct or window is not actionable (e.g., master window).
            continue
            ;;

        *)
            # Fallback for unexpected analyzer output or jq errors.
            continue
            ;;
    esac
done
