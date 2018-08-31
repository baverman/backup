#!/bin/sh
while true; do
    t=$(timew | head -1 | grep  Tracking | cut -f2 -d ' ')
    if [ -z "$t" ]; then
        echo NONE
    else
        echo $t
    fi
    sleep 10
done
