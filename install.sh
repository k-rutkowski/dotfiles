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

#var sudo

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
	echo "  --refresh-vim       prepare neovim (sync plugins)"
	echo ""
	echo "EXCLUDE OPTIONS"
	echo "  --no-cli            skip installing cli toos"
	echo "  --no-gui            skip installing gui programs"
	echo "  --no-fonts          skip installing fonts"
	echo "  --no-config         skip installing user config files"
	echo "  --no-refresh-vim    skip neovim sync"
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
	$run $sudox apt install -y git git-doc git-lfs git-man python3 python3-pip vim curl clang-tools clang-tidy clang-format g++ g++-multilib cmake nodejs npm net-tools htop rename tmux
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
	$run bob complete bash >> "$bash_completions_dir/bob"
	$run bob install nightly
	## neovim 
	#echo "> neovim..."
	#$run curl -sS -L -o /tmp/nvim-linux64.deb https://github.com/neovim/neovim/releases/download/v0.8.3/nvim-linux64.deb
	#$run $sudox apt install /tmp/nvim-linux64.deb
	#$run rm /tmp/nvim-linux64.deb
}

install_gui_tools() {
	get_sudo

	## window manager
	$run $sudox apt install -y i3

	# todo
	echo "> nothing yet"
	## email client, spotify, slack
}

install_fonts() {
	get_sudo
 	$run $sudox apt install -y fonts-powerline ttf-mscorefonts-installer
	$run $sudox apt autoremove -y

	# todo
}

copy_configs() {
	local dir=$(print_dotfiles_dir)
	local files="vimrc vim bash_aliases bash_extra tmux.conf tmux-themepack config/starship.toml"
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
	$run mkdir -p "$backup_dir/.config"
	$run mkdir -p $HOME/.config
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
		$run echo -e "\n$import_bash_extra_line\n" >> $HOME/.bashrc
	fi

	## gitconfig 
	local import_gitconfig_line="path = $dir/gitconfig"
	$run touch $HOME/.gitconfig
	if ! grep -q "$import_gitconfig_line" $HOME/.gitconfig; then
		$run echo -e "[include]\n\t$import_gitconfig_line" >> $HOME/.gitconfig
	fi

	## neovim config
	local nvim_config=$HOME/.config/nvim
	if [[ -d $nvim_config ]]; then
		$run rm -rf $nvim_config
	fi
	$run git clone https://github.com/AstroNvim/AstroNvim $nvim_config
	$run mkdir -p $nvim_config/lua
	$run ln -s "$dir/config/astronvim-user" $nvim_config/lua/user
}

refresh_nvim() {
	$run nvim  --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
}


################################################################################

error=""
need_help=0
need_update_os=0
need_install_cli=0
need_install_gui=0
need_install_fonts=0
need_config=0
need_refresh_vim=0

parse_args() {
	if [[ $# -eq 0 ]]; then
		need_help=1
		return 0
	fi

	local no_install_cli=0
	local no_install_gui=0
	local no_install_fonts=0
	local no_config=0
	local no_refresh_vim=0

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

			--refresh-vim)
				need_refresh_vim=1
				shift
				;;
			--no-refresh-vim)
				no_refresh_vim=1
				shift
				;;

			-a|--all)
				need_install_cli=1
				need_install_gui=1
				need_install_fonts=1
				need_config=1
				need_refresh_vim=1
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
	need_refresh_vim=$(($need_refresh_vim-$no_refresh_vim))

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
		copy_configs
		echo ""
	fi

	if [[ $need_refresh_vim -eq 1 ]]; then
		echo "--- Preparing neovim ---------------------------------------"
		refresh_nvim
		echo ""
	fi
}

main $@
