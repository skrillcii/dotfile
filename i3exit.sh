#!/bin/sh
# To create symbolic link in /usr/local/bin, run the command below
# sudo ln -s /full/path/to/your/i3wm.sh /usr/local/bin/name_of_new_command

# After creating the symbolic link, make this file executable by following command:
# chmod +x /full/path/to/your/i3wm.sh

lock() {
    i3lock
}

case "$1" in
    lock)
        i3lock -t -i /usr/share/backgrounds/clock_by_Bernhard_Hanakam.png
        ;;
    logout)
        i3-msg exit
        ;;
    suspend)
        i3lock -t -i /usr/share/backgrounds/clock_by_Bernhard_Hanakam.png && systemctl suspend
        ;;
    hibernate)
        i3lock -t -i /usr/share/backgrounds/clock_by_Bernhard_Hanakam.png && systemctl hibernate
        ;;
    reboot)
        systemctl reboot
        ;;
    shutdown)
        systemctl poweroff
        ;;
    *)
        echo "Usage: $0 {lock|logout|suspend|hibernate|reboot|shutdown}"
        exit 2
esac

exit 0
