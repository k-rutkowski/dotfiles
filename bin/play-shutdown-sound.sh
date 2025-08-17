#!/bin/bash

FILES=(
    "$HOME/.config/assets/sounds/Windows_XP_Down.mp3"
)

# Pick one at random
choice=${FILES[RANDOM % ${#FILES[@]}]}

paplay "$choice"

