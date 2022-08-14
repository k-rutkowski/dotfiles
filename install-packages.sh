#!/bin/bash

sudo apt update -y
sudo apt dist-upgrade -y
sudo apt install -y curl python3 python3-pip git git-doc git-lfs git-man clang-tools clang-tidy clang-format g++ g++-multilib neovim tmux golang golang-doc fonts-powerline
pip install --user powerline-shell

sudo apt install -y ttf-mscorefonts-installer
