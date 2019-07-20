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

## backup existing dotfiles
mkdir -p "$backup_dir"
for file in $files; do
  mv ~/.$file "$backup_dir/$file"
done

## create symlinks
for file in $files; do
  ln -s "$dir/$file" ~/.$file
done


cd $dir
git submodule update --init --recursive
