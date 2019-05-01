#!/bin/sh

d=$(dirname $0)

UWSGI_DISABLE_LOGGING=1 live-server.py &
on-change --fifo /tmp/live-server.fifo -- "$@"
