#!/bin/sh

exe=`( cat ~/bin/menu.lst && dmenu_path ) | dmenu -nb '#222222' -nf '#aaaaaa' -sb '#535d6c' -sf '#ffffff' -fn 'Helvetica-11'`
exitcode=$?

[ $exitcode = 0 ] && exec $exe

