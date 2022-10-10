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

## install stuff from distro repository
echo "Installing core dependencies..."
$sudox apt install -y curl python3 python3-pip git git-doc git-lfs git-man clang-tools clang-tidy clang-format g++ g++-multilib tmux fonts-powerline nodejs npm htop ripgrep rename

#$sudox apt install -y ttf-mscorefonts-installer

## cleanup after installation
$sudox apt autoremove -y

## fuzzy finder
rm -rf $HOME/.fzf
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install --all

## better cd
bash <(curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh)

## starship prompt
sh <(curl -sS https://starship.rs/install.sh) -y

## newest rust
echo "Installing rust..."
sh <(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs) -y
source "$HOME/.cargo/env"
mkdir -p $HOME/.local/share/bash-completion/completions
rustup completions bash > $HOME/.local/share/bash-completion/completions/rustup

## neovim 8.0
echo "Installing neovim..."
curl -sS -L -O https://github.com/neovim/neovim/releases/download/v0.8.0/nvim-linux64.deb
$sudox apt install ./nvim-linux64.deb
rm ./nvim-linux64.deb

echo
echo "-------------------------------------------------"
echo "Finished! You should probabily restart the shell."
echo "-------------------------------------------------"
echo "Additional requirements (to install manually):"
echo "  * https://www.nerdfonts.com/" 
echo "-------------------------------------------------"
echo
