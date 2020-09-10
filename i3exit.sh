#!/bin/sh
# To create symbolic link in /usr/local/bin, run the command below
# sudo ln -s ~/dotfile/i3exit.sh /usr/local/bin/i3exit

# After creating the symbolic link, make this file executable by following command:
# chmod +x /full/path/to/your/i3exit.sh

lock() {
    i3lock
}

case "$1" in
    lock)
        i3lock -t -i ~/Pictures/screenlock/screenlock.png
        ;;
    logout)
        #i3-msg exit
        exec dm-tool switch-to-greeter
        ;;
    suspend)
        i3lock -t -i /usr/share/backgrounds/ubuntu-default-greyscale-wallpaper.png && systemctl suspend
        ;;
    hibernate)
        i3lock -t -i /usr/share/backgrounds/ubuntu-default-greyscale-wallpaper.png && systemctl hibernate
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
