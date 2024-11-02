#!/bin/bash

config_file="$HOME/.dotfiles/ch57x-macropad/mapping.yaml"
programming_tool="$(which ch57x-keyboard-tool)"
sudox=""


get_sudo() {
	if [[ -n $sudox || $EUID = 0 ]]; then
		return 0
	fi

	if ! sudo true; then
		echo "Wrong password"
		exit 2
	fi

	sudox="sudo"
}


main() {
	set -e

	echo "programming tool: $programming_tool"
	echo "used config file: $config_file"
	echo

	if [[ ! -f $config_file ]]; then
		echo "Config file $config_file not found"
		exit 1
	fi

	if [[ ! -x $programming_tool ]]; then
		echo "Program $programming_tool not found"
		exit 1
	fi

	local cmd=""
	if [[ -n "$1" ]]; then
		cmd="$1"
	else
		cmd="upload"
		get_sudo
	fi

	#command cat $config_file | $sudox $programming_tool "$cmd"
	$sudox $programming_tool "$cmd" $config_file

	if [[ $? -eq 0 ]]; then
		echo "Successfully uploaded config"
		return 0
	else
		echo "Failed to upload config"
		return 1
	fi
}

main "$@"
