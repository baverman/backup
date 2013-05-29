#!/bin/sh

notipy &
bmpanel2 &
gatotray &
orcsome -l /tmp/orcsome.log &
feh --bg-center wallpapers/story.png
#xcompmgr -cC -t-5 -l-5 -r4.2 -o.55 &

exec openbox
