#!/bin/bash
set -e

source="${BASH_SOURCE[0]}"
while [ -h "$source" ]; do # resolve $source until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$source" )" && pwd )"
  source="$(readlink "$source")"
  [[ $source != /* ]] && source="$DIR/$source" # if $source was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done

dir="$( cd -P "$( dirname "$source" )" && pwd )"

## pull submodules
cd $dir
git submodule update --init --recursive
cd -

backup_dir="$dir-$(date "+%Y-%m-%d-%H%M")"
files="vimrc vim bash_aliases bash_extra gitconfig tmux.conf tmux-themepack config/starship.toml"

## backup existing dotfiles and create symlinks to new ones
if [[ -d $backup_dir ]]; then
  rm -rf $backup_dir
fi
mkdir -p "$backup_dir/.config"
mkdir -p "$HOME/.config"
for fname in $files; do
  file="$HOME/.$fname"
  if [[ -e $file ]]; then
    mv $file "$backup_dir/.$fname"
  elif [[ -h $file ]]; then
    rm $file
  fi
  ln -s "$dir/$fname" $file
done

## add extra .bashrc configuration
import_bash_extra_line='. "$HOME/.bash_extra"'
if ! grep -q "^$import_bash_extra_line\$" "$HOME/.bashrc"; then
  echo -e "\n$import_bash_extra_line\n" >> "$HOME/.bashrc"
fi

## neovim config
nvim_config=$HOME/.config/nvim
if [[ -d $nvim_config ]]; then
  rm -rf $nvim_config
fi
git clone https://github.com/AstroNvim/AstroNvim $nvim_config
mkdir -p $nvim_config/lua
ln -s "$dir/config/astronvim-user" $nvim_config/lua/user
nvim  --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

## install vim plugins
vim +PluginInstall +qall

echo
echo "-------------------------------------------------"
echo "Finished! You should probably restart the shell."
echo "-------------------------------------------------"
echo
