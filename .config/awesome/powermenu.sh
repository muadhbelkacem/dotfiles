#!/bin/sh

# Use printf with literal newlines for POSIX compatibility
options="Lock
Reboot
Shutdown
Logout
Cancel"

chosen=$(printf "%s" "$options" | rofi -dmenu -p "Power Menu" -i)

case "$chosen" in
    "Lock") slock ;;
    "Reboot") systemctl reboot ;;
    "Shutdown") systemctl poweroff ;;
    "Logout") echo 'awesome.quit()' | awesome-client ;;
    *) exit 0 ;;
esac
