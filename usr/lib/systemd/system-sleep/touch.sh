#!/bin/sh

if [ "$1" = "pre" ]; then
    rmmod i2c_hid
else
    sleep 3
    modprobe i2c_hid
fi
