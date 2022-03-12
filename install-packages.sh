#!/bin/bash

sudo apt update -y
sudo apt dist-upgrade -y
sudo apt install -y python3 python3-pip git git-doc git-lfs git-man clang-tools clang-tidy clang-format g++ g++-multilib neovim tmux golang golang-doc
pip install powerline-shell
