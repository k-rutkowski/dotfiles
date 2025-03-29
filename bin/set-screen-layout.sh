#!/bin/bash

set -e

if [ -z "$1" ]; then
	echo "Usage: $0 <layout>"
	exit 1
fi

layout_dir="$HOME/.screenlayout"

rm -f "$layout_dir/current" || true
ln -s "$layout_dir/$1.sh" "$layout_dir/current"

