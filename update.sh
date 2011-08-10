#!/bin/sh

copy_files () {
	[ -d $1 ] || mkdir -p $1
	cp -r ~/$1/* $1
}

copy_files .config/openbox
copy_files .config/orcsome
copy_files .config/bmpanel2
copy_files .themes/Awesome
copy_files .local/share/bmpanel2/themes/awesome

cp ~/.Xdefaults ./
