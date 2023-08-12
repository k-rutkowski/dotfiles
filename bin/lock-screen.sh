#!/bin/bash

get_random_file() {
  local dir="$1"
  if [ ! -d "$dir" ]; then
    return 1
  fi

  local filename=$(command ls $dir | sort -R | head -n 1)
  if [ -z "$filename" ]; then
    return 2
  fi

  echo "$dir/$filename"
}

image_path=$(get_random_file "$HOME/Pictures/lockscreen")
tmpdir="/tmp/lockscreen"
screen_path="$tmpdir/screen.png"


restore() {
  xset dpms 0 0 0
  rm "$tmpdir"/*
}

trap restore HUP INT TERM
xset +dpms dpms 0 0 5
mkdir -p "$tmpdir"
scrot -d 1 "$screen_path"
convert -scale 10% -scale 1000% "$screen_path" "$screen_path"
convert -blur 0x1 "$screen_path" "$screen_path"

if [ -f "$image_path" ]; then
  convert -composite "$screen_path" $image_path -gravity South -geometry +1200x20 "$screen_path"
fi

i3lock -i "$screen_path" -t
restore
