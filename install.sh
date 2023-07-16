#!/bin/bash

script_name=$0
run=""
sudox=""

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

help() {
	echo "USAGE: $script_name [OPTION...]"
	echo
	echo "MAIN OPTIONS"
	echo "  -h, --help          show help"
	echo "  -a, --all           install and configure everyghing"
	echo ""
	echo "INCLUDE OPTIONS"
	echo "  --cli               install cli toos"
	echo "  --gui               install gui programs"
	echo "  --fonts             install fonts"
	echo "  --config            install user settings in \$HOME"
	echo ""
	echo "EXCLUDE OPTIONS"
	echo "  --no-cli            skip installing cli toos"
	echo "  --no-gui            skip installing gui programs"
	echo "  --no-fonts          skip installing fonts"
	echo "  --no-config         skip installing user config files"
	echo ""
	echo "TESTING OPTIONS"
	echo "  --mock              don't do anything, just print the steps"
	echo ""
}

get_sudo() {
	if [[ -n $sudox || $EUID = 0 ]]; then
		return 0
	fi

	if ! sudo true; then
		echoerr "Wrong password"
		exit 69
	fi

	sudox="sudo"
}

## resolves the directory of this script (following symlinks)
print_dotfiles_dir() {
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

update_os() {
	get_sudo
	$run $sudox apt update -y
	$run $sudox apt dist-upgrade -y
}

install_cli_tools() {
	## apt packages
	get_sudo
	echo "> core packages..."
	$run $sudox apt install -y git git-doc git-lfs git-man python3 python3-pip python3-venv python-is-python3 vim curl clang-tools clang-tidy clang-format g++ g++-multilib cmake nodejs npm net-tools htop rename tmux ranger p7zip-full imagemagick wifi-qr
	$run $sudox apt autoremove -y

	## make sure a directory for bash completions exists
	local bash_completions_dir="$HOME/.local/share/bash-completion/completions"
	$run mkdir -p "$bash_completions_dir"

	## fuzzy finder
	echo "> fzf..."
	$run rm -rf $HOME/.fzf
	$run git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
	$run $HOME/.fzf/install --all

	## rust
	echo "> rust..."
	$run curl --proto '=https' --tlsv1.2 -sSf -o /tmp/rustup-install.sh https://sh.rustup.rs
	$run sh /tmp/rustup-install.sh -y
	$run rm /tmp/rustup-install.sh
	$run source "$HOME/.cargo/env"
	$run rustup completions bash > "$bash_completions_dir/rustup"

	## better cd
	echo "> zoxide..."
	$run curl -sS -o /tmp/zoxide-install.sh https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh
	$run bash /tmp/zoxide-install.sh
	$run rm /tmp/zoxide-install.sh

	## starship prompt, better ls, better cat, better grep, better du, better git diff
	echo "> better coreutils..."
	$run cargo install starship exa bat ripgrep du-dust git-delta

	## neovim version manager
	echo "> neovim (with bob version manager)..."
	$run cargo install bob-nvim
	if [[ -z "$run" ]]; then
		bob complete bash >> "$bash_completions_dir/bob"
	else
		$run bob complete bash ">>" "$bash_completions_dir/bob"
	fi
	$run bob use nightly
	
	## make vim the default editor
	$run $sudox update-alternatives --set editor "$(which vim.basic)"
}

install_gui_tools() {
	get_sudo

	## window manager, terminal emulator
	$run $sudox apt install -y i3 polybar rofi kitty pavucontrol lxappearance nitrogen papirus-icon-theme

	## some useful tools
	$run $sudox apt install -y qutebrowser

	## multimedia
	$run $sudox apt install -y vlc smplayer

	## requirement for image preview in ranger
	$run pip install Pillow

	## ad blocker for qutebrowser
	$run pip install adblock

	## make kitty the default terminal
	$run $sudox update-alternatives --set x-terminal-emulator "$(which kitty)"

	# todo
	## email client, spotify, slack

	## stuff from flathub
	#$run flatpak install spotify
}

install_fonts() {
	get_sudo

	## accept mscorefonts eula
	echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | $run $sudox debconf-set-selections
	echo ttf-mscorefonts-installer msttcorefonts/present-mscorefonts-eula note | $run $sudox debconf-set-selections

	## install microsoft fonts
	$run $sudox apt install -y ttf-mscorefonts-installer
	$run $sudox apt autoremove -y

	## download and install Nerd fonts
	local fonts="CascadiaCode JetBrainsMono"
	$run mkdir -p  "$HOME/.local/share/fonts"
	for font in $fonts; do
		$run rm -fr "/tmp/$font" "/tmp/$font.zip"
		$run curl -sS -L -o "/tmp/$font.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/$font.zip"
		$run unzip "/tmp/$font.zip" -d "/tmp/$font"
		$run cp -f /tmp/$font/*.ttf $HOME/.local/share/fonts/
		$run rm -fr "/tmp/$font" "/tmp/$font.zip"
	done

	$run fc-cache -fr
}

install_configs() {
	local dir=$(print_dotfiles_dir)
	local files="vimrc vim bash_aliases bash_extra tmux.conf tmux-themepack bin config/nvim config/i3 config/polybar config/rofi config/picom config/starship.toml config/ranger/rc.config"
	local backup_dir="$dir-$(date "+%Y-%m-%d-%H%M")"

	## pull submodules
	(
		$run cd $dir
		$run git submodule update --init --recursive
	)

	## backup existing dotfiles and create symlinks to the new ones
	if [[ -d $backup_dir ]]; then
		$run rm -rf $backup_dir
	fi
	$run mkdir -p "$backup_dir/.config/ranger"
	$run mkdir -p $HOME/.config/ranger
	for fname in $files; do
		file=$HOME/.$fname
		if [[ -e $file ]]; then
			$run mv $file "$backup_dir/.$fname"
		elif [[ -h $file ]]; then
			$run rm $file
		fi
		$run ln -s "$dir/$fname" $file
	done

	## add extra .bashrc configuration
	local import_bash_extra_line='. $HOME/.bash_extra'
	if ! grep -q "^$import_bash_extra_line\$" $HOME/.bashrc; then
		if [[ -z "$run" ]]; then
			echo -e "\n$import_bash_extra_line\n" >> $HOME/.bashrc
		else
			$run echo -e "\n$import_bash_extra_line\n" ">>" $HOME/.bashrc
		fi
	fi

	## gitconfig 
	local import_gitconfig_line="path = $dir/gitconfig"
	$run touch $HOME/.gitconfig
	if ! grep -q "$import_gitconfig_line" $HOME/.gitconfig; then
		if [[ -z "$run" ]]; then
			echo -e "[include]\n\t$import_gitconfig_line" >> $HOME/.gitconfig
		else
			$run echo -e "[include]\n\t$import_gitconfig_line" ">>" $HOME/.gitconfig
		fi
	fi
}

################################################################################

error=""
need_help=0
need_update_os=0
need_install_cli=0
need_install_gui=0
need_install_fonts=0
need_config=0

parse_args() {
	if [[ $# -eq 0 ]]; then
		need_help=1
		return 0
	fi

	local no_install_cli=0
	local no_install_gui=0
	local no_install_fonts=0
	local no_config=0

	while [[ $# -gt 0 ]]; do
		case $1 in
			-h|--help)
				need_help=1
				return 0
				;;

			--cli)
				need_install_cli=1
				shift
				;;
			--no-cli)
				no_install_cli=1
				shift
				;;

			--gui)
				need_install_gui=1
				shift
				;;
			--no-gui)
				no_install_gui=1
				shift
				;;

			--fonts)
				need_install_fonts=1
				shift
				;;
			--no-fonts)
				no_install_fonts=1
				shift
				;;

			--config)
				need_config=1
				shift
				;;
			--no-config)
				no_config=1
				shift
				;;

			-a|--all)
				need_install_cli=1
				need_install_gui=1
				need_install_fonts=1
				need_config=1
				shift
				;;

			--mock)
				run="mockrun"
				shift
				;;

			*)
				error="invalid argument '$1'"
				need_help=1
				return 1
				;;
		esac
	done

	need_install_cli=$(($need_install_cli-$no_install_cli))
	need_install_gui=$(($need_install_gui-$no_install_gui))
	need_install_fonts=$(($need_install_fonts-$no_install_fonts))
	need_config=$(($need_config-$no_config))

	if [[ $need_install_cli -eq 1 || $need_install_gui -eq 1 || $need_install_fonts -eq 1 ]]; then
		need_update_os=1
	fi
}

main() {
	parse_args $@

	if [[ -n $error || $need_help -ne 0 ]]; then
		local parse_args_res=$?
		if [[ -n $error ]]; then
			echoerr "ERROR: $error"
		fi
		if [[ $need_help -ne 0 ]]; then
			help
		fi
		exit $parse_args_res
	fi

	set -e

	if [[ $need_update_os -eq 1 ]]; then
		echo "--- Updating the system ------------------------------------"
		update_os
		echo ""
	fi

	if [[ $need_install_cli -eq 1 ]]; then
		echo "--- Installing CLI tools -----------------------------------"
		install_cli_tools
		echo ""
	fi

	if [[ $need_install_gui -eq 1 ]]; then
		echo "--- Installing GUI tools -----------------------------------"
		install_gui_tools
		echo ""
	fi

	if [[ $need_install_fonts -eq 1 ]]; then
		echo "--- Installing fonts ---------------------------------------"
		install_fonts
		echo ""
	fi

	if [[ $need_config -eq 1 ]]; then
		echo "--- Copying config files -----------------------------------"
		install_configs
		echo ""
	fi
}

main $@
