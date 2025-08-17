#!/bin/bash

FILES=(
    "$HOME/.config/assets/sounds/Windows_98.wav"
    "$HOME/.config/assets/sounds/Windows_XP.wav"
    "$HOME/.config/assets/sounds/Windows_Vista_7_8_10.wav"
)

# Pick one at random
choice=${FILES[RANDOM % ${#FILES[@]}]}

paplay "$choice"

