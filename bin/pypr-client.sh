#!/bin/bash

#socat - "UNIX-CONNECT:${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.pyprland.sock" <<< $@

socket_path=$(find ${XDG_RUNTIME_DIR}/hypr -name ".pyprland.sock")
#echo "path: $socket_path"

socat - "UNIX-CONNECT:$socket_path" <<< $@

