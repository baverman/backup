#if [ "$PS1" ] ; then
#    mkdir -m 0700 /dev/cgroup/cpu/user/$$
#    echo $$ > /dev/cgroup/cpu/user/$$/tasks
#fi

# Check for an interactive session
[ -z "$PS1" ] && return

alias ls='ls --color=auto'
alias ll='ls -la'
alias mc='mc -u'
alias vimdiff=meld

PS1='\[\033[01;34m\]\w\[\033[31m\]$(__git_ps1 "[%s]")\[\033[01;32m\]$(__prompt_stgit)\[\033[01;34m\]$\[\033[00m\] '

export PATH=$HOME/bin:$PATH
export PROMPT_COMMAND=
export HISTCONTROL=ignoredups
export HISTFILESIZE=5000
export HISTSIZE=5000
shopt -s histappend

export PAGER=most
export EDITOR=vim

export TERM=xterm-256color

export PIP_DOWNLOAD_CACHE=~/.cache/pip
export MPD_HOST=~/.mpd/socket

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1

_xfunc git __git_ps1 &>/dev/null
for fname in ~/.bash_sources/*; do
    . $fname
done

__fab_tasks() {
    local prev cur
    _get_comp_words_by_ref cur prev
    COMPREPLY=( $( compgen -W "`fab -l -F short`" -- "$cur" ) )
    return 0
} &&
complete -F __fab_tasks fab

__svial() {
    local prev cur
    _get_comp_words_by_ref cur prev
    COMPREPLY=( $( compgen -W "`find $HOME/.vim/sessions -mindepth 1 -type d | xargs --replace=^ basename ^`" -- "$cur"  ) )
    return 0
}
complete -F __svial svial

export SDL_AUDIODRIVER=alsa

export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python2
export PYTHONSTARTUP="$HOME/work/python-shell-enhancement/pythonstartup.py"

. /usr/bin/virtualenvwrapper.sh
