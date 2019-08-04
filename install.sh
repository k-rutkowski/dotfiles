#!/bin/bash

source="${BASH_SOURCE[0]}"
while [ -h "$source" ]; do # resolve $source until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$source" )" && pwd )"
  source="$(readlink "$source")"
  [[ $source != /* ]] && source="$DIR/$source" # if $source was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done

dir="$( cd -P "$( dirname "$source" )" && pwd )"
backup_dir=~/dotfiles-bckp
files="vimrc vim bash_aliases bash_extra"

#echo "source: $source"
#echo "dir: $dir"
#echo "backup dir: $backup_dir"
#echo "files: $files"
#exit 0

## backup existing dotfiles and create symlinks to new ones
mkdir -p "$backup_dir"
for file in $files; do
  if [[ -f ~/.$file || -d ~/.$file ]]; then
    mv ~/.$file "$backup_dir/$file"
  fi
  ln -s "$dir/$file" ~/.$file
done

## neovim config
nvim_config_dir=~/.config/nvim
nvim_config_path=$nvim_config_dir/init.vim
if [[ -f $nvim_config_path ]]; then
  mkdir -p "$backup_dir/.config/nvim"
  mv $nvim_config_path "$backup_dir/.config/nvim"
fi
mkdir -p $nvim_config_dir
ln -s "$dir/nvimrc" $nvim_config_path

## checkout vim plugin manager
cd $dir
git submodule update --init --recursive

## install vim plugins
vim +PluginInstall +qall
cd vim/bundle/YouCompleteMe
python3 install.py --clang-completer
