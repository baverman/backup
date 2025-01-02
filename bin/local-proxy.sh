#!/bin/bash
exec ssh -o ServerAliveInterval=10 -o ServerAliveCountMax=1 -ND 0.0.0.0:1080 pg.remote
#exec ssh -o ServerAliveInterval=10 -o ServerAliveCountMax=1 -S none -v -NL 0.0.0.0:1080:127.0.0.1:1080 pg.remote
