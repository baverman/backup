#!/bin/sh

source ~/backup/xinit.$MYROLE

set_kbd_map() {
    setxkbmap -model pc104 -layout us,ru -variant winkeys -option grp:caps_toggle,grp_led:$kbd_indicator,compose:ralt
}
export -f set_kbd_map

xrdb -merge ~/.Xdefaults
xset r rate 200 40
urxvtd -q -f -o

set_kbd_map

kbdd
devmon &> /tmp/devmon.log &

exec dbus-launch --exit-with-session openbox --startup ~/bin/box-session.sh
