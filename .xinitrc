#!/bin/sh
set -x

profile=~/backup/profiles/$MYROLE
source $profile/xinit
KI=$kbd_indicator
mkdir -p /tmp/opera-index

set_kbd_map() {
    xset r rate 200 40
    setxkbmap -model pc104 -layout us,ru -variant winkeys -option grp:caps_toggle,grp_led:$KI,compose:ralt,terminate:ctrl_alt_bksp
    xmodmap -e "keycode 115 = Insert"
}
export -f set_kbd_map

xrdb -merge ~/.Xdefaults
[ -f $profile/xdefaults ] && xrdb -merge $profile/xdefaults

urxvtd -q -o  &

set_kbd_map

devmon &> /tmp/devmon.log &

track-status.sh | dzen2 -fg white -x 1750 -y 4 -w 60 &
local-proxy.sh &> /tmp/proxy.log &

# killall gpg-agent
# gpg-agent --daemon

# exec dbus-launch --exit-with-session openbox --startup ~/bin/box-session.sh
dbus-update-activation-environment DISPLAY XAUTHORITY
exec openbox --startup ~/bin/box-session.sh
