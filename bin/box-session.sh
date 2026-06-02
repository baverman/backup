#!/bin/bash
set -x
/opt/bin/taskbar &>> /tmp/bg.log &
gatotray &>> /tmp/bg.log &
sleep 1
/opt/bin/battray &>> /tmp/bg.log &
PYTHONPATH=~/work/orcsome python -m orcsome -l /tmp/orcsome.log &>> /tmp/bg.log &
#xcompmgr -cC -t-5 -l-5 -r4.2 -o.55 &
