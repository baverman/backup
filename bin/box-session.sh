#!/bin/bash
set -x
bmpanel2 --theme ${BMPANEL_THEME:-awesome} &
gatotray &
orcsome -l /tmp/orcsome.log &
#xcompmgr -cC -t-5 -l-5 -r4.2 -o.55 &
