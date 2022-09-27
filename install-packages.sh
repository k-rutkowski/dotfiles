#!/bin/bash

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
$sudox apt update -y
$sudox apt dist-upgrade -y

## install the basic stuff
$sudox apt install -y curl python3 python3-pip git git-doc git-lfs git-man clang-tools clang-tidy clang-format g++ g++-multilib tmux fonts-powerline 

## install some cool tools
sudo apt install -y zoxide

#$sudox apt install -y ttf-mscorefonts-installer
$sudox apt autoremove -y

## neovim 7.2
curl -L -O https://github.com/neovim/neovim/releases/download/v0.7.2/nvim-linux64.deb
$sudox apt install ./nvim-linux64.deb
rm ./nvim-linux64.deb

## newest rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rustup-init
sh /tmp/rustup-init -y
rm -f /tmp/rustup-init
mkdir -p $HOME/.local/share/bash-completion/completions
rustup completions bash > $HOME/.local/share/bash-completion/completions/rustup
source "$HOME/.cargo/env"

