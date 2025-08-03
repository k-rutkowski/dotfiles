#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $SCRIPT_DIR/helper.sh

script_name=$0
run=""
sudox=""


help() {
	echo "USAGE: $script_name [OPTION...]"
	echo
	echo "MAIN OPTIONS"
	echo "  -h, --help          show help"
	echo "  -a, --all           install and configure everyghing"
	echo ""
	echo "INCLUDE OPTIONS"
	echo "  --desktop           install gui programs"
	echo "  --sudoers           update user's privileges"
	echo "  --dots              install user settings in \$HOME"
	echo ""
	echo "EXCLUDE OPTIONS"
	echo "  --no-desktop        skip installing gui programs"
	echo "  --no-sudoers        skip updating privileges"
	echo "  --no-dots           skip installing user config files"
	echo ""
	echo "TESTING OPTIONS"
	echo "  --mock              don't do anything, just print the steps"
	echo ""
}


update_os() {
	get_sudo
	$run $sudox pacman -Syyu --noconfirm
}

install_cli_tools() {
	## apt packages
	get_sudo
	$run $sudox dpkg --add-architecture i386
	update_os

	echo "> core packages..."
	$run $sudox apt install -y lsd git git-doc git-lfs git-man tldr python3 python3-pip python3-venv python-is-python3 curl wget nfs-common clang-tools clang-tidy clang-format g++ g++-multilib cmake nodejs npm net-tools libfuse2 cifs-utils htop rename tmux ranger p7zip-full imagemagick wifi-qr os-prober xdotool xclip entr neofetch software-properties-common apt-transport-https playerctl pulseaudio-utils pulsemixer jq
	$run $sudox apt autoremove -y

	## make sure a directory for bash completions exists
	local bash_completions_dir="$HOME/.local/share/bash-completion/completions"
	$run mkdir -p "$bash_completions_dir"

	## fuzzy finder
	echo "> fzf..."
	$run rm -rf "$HOME/.fzf"
	$run git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
	$run "$HOME/.fzf/install" --all

	## neovim
	echo "> neovim..."
	$run $sudox snap install nvim --classic
	$run $sudox update-alternatives --install /usr/bin/editor editor /snap/bin/nvim 1111
	$run $sudox snap alias nvim editor

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
	$run cargo install starship bat ripgrep du-dust git-delta

	echo "> macropad programming tool..."
	$run cargo install ch57x-keyboard-tool

	## flathub
	$run $sudox apt install -y flatpak
	$run $sudox flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

install_gui_tools() {
	get_sudo

	## window manager, terminal emulator, file manager
	$run $sudox apt install -y i3 polybar rofi kitty arandr picom lxappearance gtk-chtheme nitrogen papirus-icon-theme shutter xautolock thunar

	## device managers
	$run $sudox apt install -y pavucontrol blueman policykit-1-gnome

	## some useful tools
	$run $sudox apt install -y qemu-kvm virt-manager screenkey

	## multimedia
	$run $sudox apt install -y vlc smplayer v4l2loopback-dkms v4l2loopback-utils

	## make kitty the default terminal
	$run $sudox update-alternatives --set x-terminal-emulator "$(which kitty)"

	## email client, spotify, slack
	$run $sudox snap install thunderbird libreoffice slack

	## steam
	$run $sudox apt install -y steam-installer steam-devices

	## epic
	$run flatpak install -y flathub io.github.achetagames.epic_asset_manager

	$run flatpak install -y spotify
}

install_fonts() {
	get_sudo

	$run $sudox apt install fonts-font-awesome

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

install_desktop() {
	echo "> Installing YAY..."
	$run $sudox pacman -S --noconfirm --needed git base-devel
	$run git clone https://aur.archlinux.org/yay.git && cd yay
	$run makepkg --noconfirm -si && cd ..

	## make sure a directory for bash completions exists
	local bash_completions_dir="$HOME/.local/share/bash-completion/completions"
	$run mkdir -p "$bash_completions_dir"

	echo "> Installing cli tools..."
	$run $sudox pacman -S --noconfirm neovim tar lsd git git-lfs tldr python3 curl wget cmake nodejs npm net-tools cifs-utils htop tmux ranger imagemagick os-prober xdotool xclip entr fastfetch jq starship bat zoxide ripgrep git-delta zip

	echo "> Installing audio and brightness tools..."
	$run $sudox pacman -S --noconfirm pipewire wireplumber pamixer brightnessctl

	echo "> Installing Fonts..."
	$run $sudox pacman -S --noconfirm ttf-cascadia-code-nerd ttf-cascadia-mono-nerd ttf-fira-code ttf-fira-mono ttf-fira-sans ttf-firacode-nerd ttf-iosevka-nerd ttf-iosevkaterm-nerd ttf-jetbrains-mono-nerd ttf-jetbrains-mono ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono

	echo "> Installing and enabling SDDM..."
	$run $sudox pacman -S --noconfirm sddm
	$run $sudox systemctl enable sddm.service

	echo "> Installing terminal emulator..."
	$run $sudox pacman -S --noconfirm kitty
	
	echo "> Installing Hyprland..."
	$run $sudox pacman -S --noconfirm hyprland xdg-desktop-portal-hyprland polkit-kde-agent dunst qt5-wayland qt6-wayland
	$run $sudox pacman -S --noconfirm waybar cliphist
	$run yay -S --sudoloop --noconfirm tofi swww hyprpicker hyprlock wlogout grimblast hypridle

	$run $sudox pacman -S --noconfirm nwg-look qt5ct qt6ct kvantum

	script_dir=$(safe_get_script_dir)

	$run mkdir -p "$HOME/.config/assets/backgrounds"
	$run cp -r "$script_dir/assets/backgrounds" "$HOME/.config/assets/"
	$run cp -r "$script_dir/assets/wlogout" "$HOME/.config/assets/"

	$run $sudox tar -xvf "$script_dir/assets/themes/Catppuccin-Mocha.tar.xz" -C /usr/share/themes/
	$run $sudox tar -xvf "$script_dir/assets/icons/Tela-circle-dracula.tar.xz" -C /usr/share/icons/
	$run yay -S --sudoloop --noconfirm kvantum-theme-catppuccin-git


	echo "> Desktop apps..."
	$run $sudox pacman -S --noconfirm nautilus firefox thunderbird libreoffice-fresh

	# spotify
	$run yay -S --sudoloop --noconfirm spotify

	# nextcloud
	$run yay -S --sudoloop --noconfirm nextcloud-client

	# dropbox
	$run yay -S --sudoloop --noconfirm libappindicator-gtk2 libappindicator-gtk3 dropbox dropbox-cli nautilus-dropbox

	echo
	echo "Post-installation instructions:"
	echo "-------------------------------"
	echo
	echo "Set themes and icons:"
	echo "   - Run 'nwg-look' and  set the global GTK and icon theme"
	echo "   - Open 'kvantummanager' (run with sudo for system-wide changes) to select and apply the Catppuccin theme"
	echo "   - Open 'qt6ct' to set the icon theme"
	echo
	echo "Nextcloud:"
	echo "   - First, login to nextcloud account in a browser"
	echo "   - Run Nextcloud Desktop and proceed to connect"
	echo
}

update_sudoers() {
	get_sudo

	sudoers='/etc/sudoers'
	username="$(whoami)"
	allowed_executables='/usr/bin/veracrypt /usr/sbin/grub-reboot /sbin/reboot'

	append_to_file "" "$sudoers" "$sudox"
	for exe in $allowed_executables; do
		line="$username ALL = NOPASSWD: $exe"
		append_to_file_unique "$line" "$sudoers" "$sudox"
	done
}

install_dots() {
	local dir=$(safe_get_script_dir)
	local files="vimrc vim ideavimrc bash_aliases bash_extra bin config/tmux config/nvim config/starship.toml config/ranger/rc.config config/i3 config/polybar config/rofi config/kitty config/picom config/hypr config/tofi config/waybar config/gtk-3.0 config/gtk-4.0 config/wlogout config/xsettingsd"
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
	append_to_file_unique "$import_bash_extra_line" "$HOME/.bashrc"

	## gitconfig 
	local import_gitconfig_line="path = $dir/gitconfig"
	$run touch $HOME/.gitconfig
	append_to_file_unique "[include]\n\t$import_gitconfig_line" "$HOME/.gitconfig"

	echo "Completed."
}

################################################################################

error=""
need_help=0
need_update_os=0
need_desktop=0
need_sudoers=0
need_dots=0

parse_args() {
	if [[ $# -eq 0 ]]; then
		need_help=1
		return 0
	fi

	local no_desktop=0
	local no_sudoers=0
	local no_dots=0

	while [[ $# -gt 0 ]]; do
		case $1 in
			-h|--help)
				need_help=1
				return 0
				;;

			--desktop)
				need_desktop=1
				shift
				;;
			--no-desktop)
				no_desktop=1
				shift
				;;

			--sudoers)
				need_sudoers=1
				shift
				;;
			--no-sudoers)
				no_sudoers=1
				shift
				;;

			--dots)
				need_dots=1
				shift
				;;
			--no-dots)
				no_dots=1
				shift
				;;

			-a|--all)
				need_desktop=1
				need_sudoers=1
				need_dots=1
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

	need_gui=$(($need_desktop-$no_desktop))
	need_sudoers=$(($need_sudoers-$no_sudoers))
	need_dots=$(($need_dots-$no_dots))
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

	if [[ $need_desktop -eq 1 ]]; then
		echo "--- Updating the system ------------------------------------"
		update_os
		echo ""
	fi

	if [[ $need_desktop -eq 1 ]]; then
		echo "--- Installing GUI tools -----------------------------------"
		install_desktop
		echo ""
	fi

	if [[ $need_sudoers -eq 1 ]]; then
		echo "--- Updating sudoers ---------------------------------------"
		update_sudoers
		echo ""
	fi

	if [[ $need_dots -eq 1 ]]; then
		echo "--- Copying config files -----------------------------------"
		install_dots
		echo ""
	fi
}

main $@

