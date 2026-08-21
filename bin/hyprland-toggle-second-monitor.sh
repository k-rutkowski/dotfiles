#!/bin/bash

MON="DP-2"
ON_CMD="hl.monitor({ output = '$MON', disabled = false })"
OFF_CMD="hl.monitor({ output = '$MON', disabled = true })"

hyprctl monitors | grep -q "^Monitor $MON"
if [ $? -eq 0 ]; then
    hyprctl eval "$OFF_CMD"
    echo down
else
    hyprctl eval "$ON_CMD"
    echo up
fi
