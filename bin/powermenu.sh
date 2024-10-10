#! /bin/sh

menu="\
  Lock\n\
󰍂  Log Out\n\
  Sleep\n\
  Hibernate\n\
  Reboot\n\
󰖳  Reboot to Windows\n\
  Reboot to UEFI\
  Power Off\n\
"

chosen=$(printf "  Lock\n󰍂  Log Out\n  Power Off\n  Sleep\n  Reboot\n󰖳  Reboot to Windows\n  Reboot to UEFI\n  Hibernate" | rofi -dmenu -i -theme-str '@import "power.rasi"')

case "$chosen" in
	"  Power Off") poweroff ;;
	"  Sleep") systemctl suspend ;;
	"  Reboot") systemctl reboot ;;
	"󰖳  Reboot to Windows") $HOME/.bin/reboot-to-windows.sh ;;
	"󰖳  Reboot to UEFI") systemctl reboot --firmware-setup ;;
	"  Hibernate") systemctl hibernate ;;
	"󰍂  Log Out") i3-msg exit ;;
	"  Lock") $HOME/.bin/lock-screen.sh ;;
	*) exit 1 ;;
esac
