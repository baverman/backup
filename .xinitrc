#!/bin/sh

if xrandr | grep 'HDMI1 connected'; then
    external-monitor
else
    xgamma -bgamma 0.74 -ggamma 0.95 -rgamma 1.05 &
    feh --bg-center wallpapers/story.png
fi

xinput set-button-map "ETPS/2 Elantech Touchpad" 2 1 3

xrdb -merge ~/.Xdefaults
xset r rate 200 40
urxvtd -q -f -o

setxkbmap -model pc104 -layout us,ru -variant winkeys -option grp:caps_toggle,grp_led:caps,compose:ralt

kbdd
xbacklight -set 80
devmon &> /tmp/devmon.log &

exec dbus-launch --exit-with-session ~/bin/box-session.sh
#exec ck-launch-session /usr/bin/fvwm2
#exec ck-launch-session /usr/bin/fluxbox -log /tmp/fb.log -verbose
