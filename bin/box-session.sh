#!/bin/sh

xrdb -merge ~/.Xdefaults

notipy &
bmpanel2 &
gatotray &
orcsome -l /tmp/orcsome.log &
feh --bg-center wallpapers/story.jpg

exec openbox
