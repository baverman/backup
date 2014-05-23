#!/bin/sh
import -window root /tmp/boo.png
# convert /tmp/boo.png -blur 40x10 /tmp/boo.png
convert /tmp/boo.png -filter Gaussian -resize 25% -define filter:sigma=1.25 -resize 400% /tmp/boo.png
i3lock -i /tmp/boo.png
rm /tmp/boo.png
