#!/bin/bash

MON="DP-2"
ON_CMD="$MON,1920x1080@144,-1920x0,1"
OFF_CMD="$MON,disable"

hyprctl monitors | grep -q "^Monitor $MON"
if [ $? -eq 0 ]; then
    hyprctl keyword monitor "$OFF_CMD"
	echo down
else
    hyprctl keyword monitor "$ON_CMD"
	echo up
fi
