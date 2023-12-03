#!/bin/bash
exec ssh -o ServerAliveInterval=10 -o ServerAliveCountMax=1 -ND 0.0.0.0:1080 pg.remote
