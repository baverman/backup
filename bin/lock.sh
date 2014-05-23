#!/bin/sh
import -window root /tmp/boo.png
convert /tmp/boo.png -blur 5x5 /tmp/boo.png
i3lock -i /tmp/boo.png
rm /tmp/boo.png
