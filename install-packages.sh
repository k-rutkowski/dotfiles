#!/bin/bash
set -e

if [[ "$EUID" = 0 ]]; then
    sudox=""
else
    if ! sudo true; then
        echo "Wrong password"
        exit 1
    fi
    sudox="sudo"
fi

## update the OS
echo "Updating system..."
$sudox apt update -y
$sudox apt dist-upgrade -y

## basic stuff
echo "Installing core dependencies..."
$sudox apt install -y curl python3 python3-pip git git-doc git-lfs git-man clang-tools clang-tidy clang-format g++ g++-multilib tmux fonts-powerline 
#$sudox apt install -y ttf-mscorefonts-installer

## some cool tools
# ???

## cleanup after installation
$sudox apt autoremove -y

## fuzzy finder
rm -rf $HOME/.fzf
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install --all

## better cd
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

## starship prompt
curl -sS https://starship.rs/install.sh > /tmp/starship-install.sh
sh /tmp/starship-install.sh -y
rm -f /tmp/starship-install.sh

## neovim 7.2
echo "Installing neovim..."
curl -L -O https://github.com/neovim/neovim/releases/download/v0.7.2/nvim-linux64.deb
$sudox apt install ./nvim-linux64.deb
rm ./nvim-linux64.deb

## newest rust
echo "Installing rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rustup-init
sh /tmp/rustup-init -y
rm -f /tmp/rustup-init
mkdir -p $HOME/.local/share/bash-completion/completions
source "$HOME/.cargo/env"
rustup completions bash > $HOME/.local/share/bash-completion/completions/rustup

echo
echo "-------------------------------------------------"
echo "Finished! You should probabily restart the shell."
echo "-------------------------------------------------"
echo "Additional requirements (to install manually):"
echo "  * https://www.nerdfonts.com/" 
echo "-------------------------------------------------"
echo
