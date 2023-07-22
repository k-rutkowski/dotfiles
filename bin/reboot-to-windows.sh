#!/bin/bash

#windows_title=`grep -i 'windows' /boot/grub/grub.cfg | cut -d"'" -f2`
#sudo grub-reboot "$windows_title"
#systemctl reboot

systemctl reboot --boot-loader-entry=auto-windows
