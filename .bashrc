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
alias fpyg="fpy | xargs egrep"
alias sc='sudo systemctl'

function __mercurial_qtop() {
    qtop=`hg qtop 2>/dev/null`
    [ -z "$qtop" ] || echo -n "($qtop)"
}

PS1='\[\033[01;34m\]\w\[\033[31m\]$(__git_ps1 "[%s]")\[\033[01;32m\]$(__prompt_stgit)$(__mercurial_qtop)\[\033[01;34m\]$\[\033[00m\] '

__qrefresh_to() {
    local prev cur
    _get_comp_words_by_ref cur prev
    COMPREPLY=( $( compgen -W "`hg qseries`" -- "$cur" ) )
    return 0
} &&
complete -F __qrefresh_to qrefresh-to

__fab_tasks() {
    local prev cur
    _get_comp_words_by_ref cur prev
    COMPREPLY=( $( compgen -W "`fab -l -F short`" -- "$cur" ) )
    return 0
} &&
complete -F __fab_tasks fab

export PATH=$HOME/bin:$PATH
export PROMPT_COMMAND=
export HISTCONTROL=ignoredups
export HISTFILESIZE=5000
export HISTSIZE=5000
shopt -s histappend

export PAGER=most
export EDITOR=vim
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export TERM=xterm-256color

export PIP_DOWNLOAD_CACHE=~/.cache/pip

export LOGIBOX_SSH_KEY=/home/bobrov/.ssh/lb_rsa
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python2

#_xfunc git __git_ps1 &>/dev/null

. /usr/bin/virtualenvwrapper.sh
. /usr/share/snaked/completion/bash/snaked
. /usr/share/git/git-prompt.sh
