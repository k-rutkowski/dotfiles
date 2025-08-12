#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $SCRIPT_DIR/helper.sh

script_name=$0
run=""
sudox=""


get_sudo() {
	if [[ -n $sudox || $EUID = 0 ]]; then
		return 0
	fi

	sudo -v

	if ! sudo true; then
		echoerr "Wrong password"
		exit 69
	fi

	(while true; do sudo -n true; sleep 60; done) &
	SUDO_PID=$!
	trap "kill $SUDO_PID 2>/dev/null || true" EXIT

	sudox="sudo"
}


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


add_samba_config_if_missing() {
    local CONF=/etc/samba/smb.conf

    # ensure file exists
    $run $sudox test -f "$CONF" || $run $sudox bash -c "mkdir -p \$(dirname $CONF) && :> '$CONF'"

    # if no [global] section, append the block
    if ! grep -q '^\s*\[global\]' "$CONF"; then
      $run $sudox tee -a "$CONF" > /dev/null <<'EOF'

[global]
  workgroup = WORKGROUP
  server string = %h Samba Server
  security = user
  map to guest = Bad User
EOF
      echo "Appended [global] block to $CONF"
    else
      echo "[global] already present in $CONF — no changes made"
    fi
}

update_os() {
	get_sudo
	$run $sudox pacman -Syyu --noconfirm
}

install_desktop() {
	get_sudo

	echo "> Installing basic cli tools..."
	$run $sudox pacman -S --noconfirm neovim tar less bc htop cifs-utils net-tools git git-lfs base-devel cmake make clang ninja
	$run $sudox pacman -S --noconfirm tldr python3 curl wget nodejs npm tmux ranger imagemagick os-prober xdotool xclip entr fastfetch jq lsd bat zoxide ripgrep git-delta dust rsync
	$run $sudox pacman -S --noconfirm gvfs-smb smbclient

	$run git-lfs install

	echo "> Installing YAY..."
	$run $sudox pacman -S --noconfirm --needed git base-devel
	$run git clone https://aur.archlinux.org/yay.git && cd yay
	$run makepkg --noconfirm -si && cd ..

	## make sure a directory for bash completions exists
	local bash_completions_dir="$HOME/.local/share/bash-completion/completions"
	$run mkdir -p "$bash_completions_dir"

	$run $sudox pacman -S --noconfirm zip unzip p7zip

	$run $sudox pacman -S --noconfirm bash-completion

	$run $sudox pacman -S --noconfirm rustup
	$run rustup default stable

	$run $sudox pacman -S --noconfirm starship

	echo "> Installing dependencies for various programs..."
	$run $sudox pacman -S --noconfirm libxi libxrender libxtst mesa-utils fontconfig gtk3

	echo "> Installing audio and brightness tools..."
	$run $sudox pacman -S --noconfirm pipewire pipewire-pulse pipewire-alsa pipewire-jack pavucontrol wireplumber pamixer brightnessctl

	echo "> Installing bluetooth tools..."
	$run $sudox pacman -S --noconfirm bluez bluez-utils blueman
	$run $sudox systemctl enable bluetooth

	echo "> Installing Fonts..."
	$run $sudox pacman -S --noconfirm ttf-cascadia-code-nerd ttf-cascadia-mono-nerd ttf-fira-code ttf-fira-mono ttf-fira-sans ttf-firacode-nerd ttf-iosevka-nerd ttf-iosevkaterm-nerd ttf-jetbrains-mono-nerd ttf-jetbrains-mono ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono

	echo "> Installing and enabling SDDM..."
	$run $sudox pacman -S --noconfirm sddm
	$run $sudox systemctl enable sddm.service

	echo "> Installing terminal emulator..."
	$run $sudox pacman -S --noconfirm kitty
	
	echo "> Installing desktop environment..."
	$run $sudox pacman -S --noconfirm hyprland xdg-desktop-portal-hyprland polkit-kde-agent dunst qt5-wayland qt6-wayland xorg-wayland
	$run $sudox pacman -S --noconfirm waybar cliphist
	$run yay -S --sudoloop --noconfirm tofi swww hyprpicker hyprlock wlogout hypridle

	$run $sudox pacman -S --noconfirm nwg-look qt5ct qt6ct kvantum

	echo "> Installing screenshot tools..."
	$run yay -S --sudoloop --noconfirm grimblast gradia

	script_dir=$(safe_get_script_dir)

	$run mkdir -p "$HOME/.config/assets"
	$run cp -r "$script_dir/assets/backgrounds" "$HOME/.config/assets/"
	$run cp -r "$script_dir/assets/wlogout" "$HOME/.config/assets/"

	$run $sudox tar -xvf "$script_dir/assets/themes/Catppuccin-Mocha.tar.xz" -C /usr/share/themes/
	$run $sudox tar -xvf "$script_dir/assets/icons/Tela-circle-dracula.tar.xz" -C /usr/share/icons/
	$run yay -S --sudoloop --noconfirm kvantum-theme-catppuccin-git

	# alternative package manager
	$run $sudox pacman -S --noconfirm flatpak
	$run flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

	echo "> Desktop apps..."
	#$run $sudox pacman -S --noconfirm nautilus nautilus-share
	$run $sudox pacman -S --noconfirm thunar thunar-archive-plugin thunar-media-tags-plugin thunar-shares-plugin
	$run $sudox pacman -S --noconfirm firefox thunderbird libreoffice-fresh
	$run $sudox pacman -S --noconfirm vlc vlc-plugin-ffmpeg vlc-plugin-x264 vlc-plugin-x265 
	$run $sudox pacman -S --noconfirm transmission-cli transmission-gtk

	# google-chrome
	$run yay -S --sudoloop --noconfirm google-chrome
	
	# spotify
	$run yay -S --sudoloop --noconfirm spotify

	# nextcloud
	$run yay -S --sudoloop --noconfirm nextcloud-client

	# dropbox
	$run yay -S --sudoloop --noconfirm libappindicator-gtk2 libappindicator-gtk3 dropbox dropbox-cli nautilus-dropbox

	# note taking
	$run yay -S --sudoloop --noconfirm obsidian 

	# slack
	$run yay -S --sudoloop --noconfirm slack-desktop

	# ide
	$run yay -S --sudoloop --noconfirm rider

	# vial (keyboard layout configuration)
	$run yay -S --sudoloop --noconfirm vial
	$run export USER_GID=`id -g`;
	$run sudo --preserve-env=USER_GID sh -c 'echo "KERNEL==\"hidraw*\", SUBSYSTEM==\"hidraw\", MODE=\"0660\", GROUP=\"$USER_GID\", TAG+=\"uaccess\", TAG+=\"udev-acl\"" > /etc/udev/rules.d/92-viia.rules && udevadm control --reload && udevadm trigger'

	$run add_samba_config_if_missing

	# game development
	$run flatpak install flathub io.github.achetagames.epic_asset_manager

	# gaming
	$run yay -S --sudoloop --noconfirm heroic-games-launcher

	# steam
	## todo: enable multilib repository before installing steam
	#$run $sudox pacman -S --noconfirm steam


	# backup solutions
	# $run yay -S  --sudoloop --noconfirm timeshift    ## todo: investigate

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
	echo "To install steam:"
	echo "   - Edit /etc/pacman.conf - uncomment the [multilib] section"
	echo "   - Run 'sudo pacman -Syyu' to update the package database"
	echo "   - Run 'sudo pacman -S steam' to install steam"
	echo "   - When asked for provider for vulkan-driver, select the appropriate one for your GPU"
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

