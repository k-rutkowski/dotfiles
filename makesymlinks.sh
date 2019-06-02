#!/bin/bash

source="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
dir="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
backup_dir=~/dotfiles-bckp
files="vimrc vim"

## backup existing dotfiles
mkdir -p "$backup_dir"
for file in $files; do
  mv ~/.$file "$backup_dir/$file"
done

## create symlinks
for file in $files; do
  ln -s "$dir/$file" ~/.$file
done

