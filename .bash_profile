. $HOME/.bashrc

_xfunc git __git_ps1 &>/dev/null

eval $(ssh-agent)

if [[ -z $DISPLAY && $(tty) = /dev/tty1 ]]; then
    xxx
    logout
fi
