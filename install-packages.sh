#!/bin/bash

if ! [[ "$EUID" = 0 ]]; then
    if ! sudo true; then
        echo "Wrong password"
        exit 1
    fi
fi

sudo apt update -y
sudo apt dist-upgrade -y

sudo apt install -y curl python3 python3-pip git git-doc git-lfs git-man clang-tools clang-tidy clang-format g++ g++-multilib tmux fonts-powerline 
sudo apt install -y ttf-mscorefonts-installer
sudo apt autoremove -y

# neovim 7.2
curl -L -O https://github.com/neovim/neovim/releases/download/v0.7.2/nvim-linux64.deb
sudo apt install ./nvim-linux64.deb
rm ./nvim-linux64.deb

# newest rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rustup-init
sh /tmp/rustup-init -y
rm -f /tmp/rustup-init
rustup completions bash > ~/.local/share/bash-completion/completions/rustup


