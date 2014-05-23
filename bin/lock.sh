#!/bin/sh
import -window root /tmp/boo.png
convert /tmp/boo.png -blur 40x10 /tmp/boo.png
i3lock -i /tmp/boo.png
rm /tmp/boo.png
