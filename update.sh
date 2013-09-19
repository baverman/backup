#!/bin/sh

copy_home_files () {
	[ -d $1 ] || mkdir -p $1
	cp -r ~/$1/$2 $1
}

copy_files () {
  for f in $@; do
    dir=./`dirname "$f"`
    [ -d "$dir" ] || mkdir -p "$dir"
    cp -r "$f" "$dir"
  done
}

copy_home_files .config/openbox '*'
copy_home_files .config/orcsome '*.py'
copy_home_files .config/bmpanel2 '*'
copy_home_files .themes/Awesome '*'
copy_home_files .local/share/bmpanel2/themes/awesome '*'
copy_home_files .bash_sources '*'
copy_home_files .mplayer config
copy_home_files .mplayer input.conf

copy_files /etc/X11/xorg.conf
copy_files /etc/X11/xorg.conf.d/{15,20,50}*
copy_files /etc/asound.conf

for file in box-session.sh bpython colors.sh dbus-env opera pipdc rx show-sizes stg-flush title xxx check-mail git-pull-all urxvt-clipboard fall stg-push-current menu.sh menu.lst; do
    cp ~/bin/$file bin/
done

cp ~/.Xdefaults ./
cp ~/.bashrc ~/.bash_profile ./
cp ~/.xinitrc ~/.gtkrc-2.0 ~/.gtkrc-2.0.mine ./
cp ~/.vimrc ./
