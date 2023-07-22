#! /bin/sh

chosen=$(printf "  Lock\n󰍂  Log Out\n  Power Off\n  Sleep\n  Reboot\n󰖳  Reboot to Windows\n  Hibernate" | rofi -dmenu -i -theme-str '@import "power.rasi"')

case "$chosen" in
	"  Power Off") poweroff ;;
	"  Sleep") systemctl suspend ;;
	"  Reboot") systemctl reboot ;;
	"󰖳  Reboot to Windows") $HOME/.bin/reboot-to-windows.sh ;;
	"  Hibernate") systemctl hibernate ;;
	"󰍂  Log Out") i3-msg exit ;;
	"  Lock") $HOME/.bin/lock-screen.sh ;;
	*) exit 1 ;;
esac
