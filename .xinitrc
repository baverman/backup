#/bin/sh

xset r rate 200 40
urxvtd -q -f -o

xinput set-button-map `xinput list --short "SynPS/2 Synaptics TouchPad" | awk '{ match($0, /.*=([0-9]+)/, arr); print arr[1]}'` 2 1 3

xgamma -bgamma 0.74 -ggamma 0.95 -rgamma 1.05 &

kbdd

exec ck-launch-session dbus-launch ~/bin/box-session.sh
#exec ck-launch-session /usr/bin/fvwm2
#exec ck-launch-session /usr/bin/fluxbox -log /tmp/fb.log -verbose
