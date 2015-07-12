#!/bin/sh
font=${DMENU_FONT:-"Helvetica-11"}
exe=`( cat ~/bin/menu.lst && dmenu_path ) | dmenu -nb '#222222' -nf '#aaaaaa' -sb '#535d6c' -sf '#ffffff' -fn "$font"`
exitcode=$?

[ $exitcode = 0 ] && exec $exe

