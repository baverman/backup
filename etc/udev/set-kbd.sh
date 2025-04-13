#!/bin/sh
#test -z "$NAME" && exit 0
export DISPLAY=:0
export XDG_RUNTIME_DIR=/run/user/1000
export XDG_SEAT=seat0
export XDG_SESSION_CLASS=user
export XDG_SESSION_ID=1
export XDG_SESSION_TYPE=tty
export XDG_VTNR=1
export XAUTHORITY=/home/bobrov/.Xauthority
sleep 1
(
/usr/bin/xset r rate 200 40;
/usr/bin/setxkbmap -model pc104 -layout us,ru -variant winkeys -option grp:caps_toggle,grp_led:caps,compose:ralt,terminate:ctrl_alt_bksp;
/usr/bin/xmodmap -e "keycode 115 = Insert";
/usr/bin/xmodmap -e "keycode 96 = Insert Insert Insert";
) &>> /tmp/kbd.log
