#!/bin/sh
while true; do
    ssh -o ServerAliveInterval=10 -o ServerAliveCountMax=1 -ND 1080 pg.remote
    status=$?
    echo status $status
    if [ "$status" != 143 -o "$status" != 0 ]; then
        sleep 10
    fi
done
