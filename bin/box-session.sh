#!/bin/bash
set -x
bmpanel2 --theme ${BMPANEL_THEME:-awesome} &>> /tmp/bg.log &
gatotray &>> /tmp/bg.log &
orcsome -l /tmp/orcsome.log &>> /tmp/bg.log &
#xcompmgr -cC -t-5 -l-5 -r4.2 -o.55 &
