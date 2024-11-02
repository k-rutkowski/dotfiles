#!/bin/bash

config_file="$HOME/.dotfiles/macropad/mapping.yaml"
programming_tool="$(which ch57x-keyboard-tool)"
sudox=""


get_sudo() {
	if [[ -n $sudox || $EUID = 0 ]]; then
		return 0
	fi

	if ! sudo true; then
		echo "Wrong password"
		exit 69
	fi

	sudox="sudo"
}


main() {
	get_sudo

	if [[ ! -f $config_file ]]; then
		echo "Config file not found"
		exit 1
	fi

	if [[ ! -x $programming_tool ]]; then
		echo "Programming tool not found"
		exit 1
	fi

	echo "tool: $programming_tool"
	echo "config: $config_file"

	command cat $config_file | $sudox $programming_tool upload

	if [[ $? -eq 0 ]]; then
		echo "Successfully uploaded config"
		return 0
	else
		echo "Failed to upload config"
		return 1
	fi
}

main "$@"
