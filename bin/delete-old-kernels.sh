#!/bin/bash

apt-mark showmanual ^linux- | egrep -v 'linux-base|linux-doc|linux-tools-generic' | xargs sudo apt-mark auto 
sudo apt install --reinstall linux-base linux-doc linux-tools-generic 
sudo apt autoremove --purge

boot_entries_dir="/boot/efi/loader/entries"

echo
echo "To delete bootloader entries, remove their config files from $boot_entries_dir"

