#!/bin/bash

declare i3_tree
declare instance=$1
declare mark="${instance}_fullscreen"
declare current_output
declare -i has_fullscreen_mark
declare -i is_fullscreen_mode

command -v jq-linux64 >/dev/null 2>&1 || { i3-nagbar -t warning -m "jq-linux64 is needed for toggling the quake terminal"; exit 1; }

i3_tree="$(
    i3-msg -t get_tree \
        | jq-linux64 --arg instance "$instance" '
            recurse(.nodes[])
            | .floating_nodes[]
            | select(.nodes[].window_properties.instance == $instance)
        '
)"

current_output="$(
    jq-linux64 '.output' <<<"$i3_tree"
)"

is_fullscreen_mode="$(
    jq-linux64 '.nodes[0].fullscreen_mode' <<<"$i3_tree"
)"

has_fullscreen_mark="$(
    i3-msg -t get_marks | jq-linux64 --arg mark "$mark" '
        if contains([$mark]) then
            1
        else
            0
        end
    '
)"

if [[ "$current_output" =~ i3 ]]; then
    if ((has_fullscreen_mark)); then
        i3-msg '[instance="'$instance'"] scratchpad show, fullscreen toggle, unmark'" $mark"
    else
        i3-msg '[instance="'$instance'"] scratchpad show'
    fi
else
    if ((is_fullscreen_mode)); then
        i3-msg '[instance="'$instance'"] mark --add '$mark', scratchpad show'
    else
        i3-msg '[instance="'$instance'"] scratchpad show'
    fi
fi
