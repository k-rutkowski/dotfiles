#!/bin/bash

if [ -t 1 ]; then
	print_style_mock="$(tput setaf 250)"
	print_style_error="$(tput setaf 160)"
	print_style_reset="$(tput sgr0)"
else
	print_style_mock=""
	print_style_error=""
	print_style_reset=""
fi

echoerr() { printf "%s%s%s\n" "$print_style_error" "$*" "$print_style_reset"; }
mockrun() { printf "%s%s%s\n" "$print_style_mock" "$*" "$print_style_reset"; }

## appends a line of text to a file
append_to_file() {
	local line="$1"
	local file="$2"
	local local_sudox="$3"

	if [[ -z "$run" ]]; then
		echo -e "$line" | $local_sudox tee -a $file >/dev/null
	else
		$run echo echo -e "$line" '|' $local_sudox tee -a $file
	fi
}

## appends a line of text to a file only if it's not already there
append_to_file_unique() {
	local line="$1"
	local file="$2"
	local local_sudox="$3"

	if ! $local_sudox grep -q "^$line\$" $file; then
		append_to_file "$line" "$file" "$local_sudox"
	fi
}

## resolves the directory of this script (following symlinks)
safe_get_script_dir() {
	local source="${BASH_SOURCE[0]}"
	local dir

	while [ -h "$source" ]; do
		# resolve $source until the file is no longer a symlink
		dir="$(cd -P "$(dirname "$source")" && pwd)"
		source="$(readlink "$source")"

		# if $source was a relative symlink, we need to resolve it relative to the path
		# where the symlink file was located
		[[ $source != /* ]] && source="$dir/$source"
	done

	dir="$(cd -P "$(dirname "$source")" && pwd)"
	echo "$dir"
}
