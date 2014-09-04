#!/bin/sh

source ~/backup/xinit.$MYROLE

set_kbd_map() {
    xset r rate 200 40
    setxkbmap -model pc104 -layout us,ru -variant winkeys -option grp:caps_toggle,grp_led:$kbd_indicator,compose:ralt
}
export -f set_kbd_map

xrdb -merge ~/.Xdefaults
urxvtd -q -f -o

set_kbd_map

kbdd
devmon &> /tmp/devmon.log &

killall gpg-agent
eval $(gpg-agent --daemon) &

exec dbus-launch --exit-with-session openbox --startup ~/bin/box-session.sh
