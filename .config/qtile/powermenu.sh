#!/bin/sh

options="🔒 Lock\n♻️ Reboot\n🛑 Shutdown\n🚪 Logout\n❌ Cancel"

chosen=$(echo -e "$options" | rofi -dmenu -p "Power Menu" -i)

case "$chosen" in
    "🔒 Lock") slock ;;
    "♻️ Reboot") systemctl reboot ;;
    "🛑 Shutdown") systemctl poweroff ;;
    "🚪 Logout") qtile cmd-obj -o cmd -f shutdown ;;
    *) exit 0 ;;
esac
