#!/bin/bash

if wmctrl -l | grep -q plugin-container; then
    xset -dpms
    xset dpms
fi
