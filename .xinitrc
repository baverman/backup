#/bin/sh

xrdb -merge ~/.Xdefaults
xset r rate 200 40
urxvtd -q -f -o

xinput set-button-map "ETPS/2 Elantech Touchpad" 2 1 3

xgamma -bgamma 0.74 -ggamma 0.95 -rgamma 1.05 &

kbdd
xbacklight -set 80
devmon &> /tmp/devmon.log &

exec dbus-launch --exit-with-session ~/bin/box-session.sh
#exec ck-launch-session /usr/bin/fvwm2
#exec ck-launch-session /usr/bin/fluxbox -log /tmp/fb.log -verbose
