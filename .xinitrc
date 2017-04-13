#!/bin/sh

profile=~/backup/profiles/$MYROLE
source $profile/xinit
KI=$kbd_indicator

set_kbd_map() {
    xset r rate 200 40
    setxkbmap -model pc104 -layout us,ru -variant winkeys -option grp:caps_toggle,grp_led:$KI,compose:ralt
}
export -f set_kbd_map

xrdb -merge ~/.Xdefaults
[ -f $profile/xdefaults ] && xrdb -merge $profile/xdefaults

urxvtd -q -f -o

set_kbd_map

devmon &> /tmp/devmon.log &

killall gpg-agent
eval $(gpg-agent --daemon) &

exec dbus-launch --exit-with-session openbox --startup ~/bin/box-session.sh
