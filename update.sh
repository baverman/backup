#!/bin/sh

copy_files () {
	[ -d $1 ] || mkdir -p $1
	cp -r ~/$1/$2 $1
}

copy_files .config/openbox '*'
copy_files .config/orcsome '*.py'
copy_files .config/bmpanel2 '*'
copy_files .themes/Awesome '*'
copy_files .local/share/bmpanel2/themes/awesome '*'

for file in box-session.sh bpython colors.sh dbus-env opera pipdc rx show-sizes stg-flush title xxx check-mail git-pull-all; do
    cp ~/bin/$file bin/
done

cp ~/.Xdefaults ./
cp ~/.bashrc ~/.bash_profile ./
