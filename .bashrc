#if [ "$PS1" ] ; then
#    mkdir -m 0700 /dev/cgroup/cpu/user/$$
#    echo $$ > /dev/cgroup/cpu/user/$$/tasks
#fi

# Check for an interactive session
[ -z "$PS1" ] && return

alias ls='ls --color=auto'
alias ll='ls -la'
alias mc='mc -u'
alias sc='sudo systemctl'
alias cal='cal -m'
alias ssh='TERM=xterm ssh'

PS1='\[\033[01;34m\]\w\[\033[31m\]$(__git_ps1 "[%s]")\[\033[01;32m\]$(__prompt_stgit)\[\033[01;34m\]$\[\033[00m\] '

export PATH=$HOME/bin:$HOME/.local/bin:$PATH
export PROMPT_COMMAND='history -a'
export HISTCONTROL=ignoredups:ignorespace
export HISTFILESIZE=15000
export HISTSIZE=15000
shopt -s histappend

export PAGER=most
export EDITOR=vim

# export TERM=xterm-256color

# export PIP_DOWNLOAD_CACHE=~/.cache/pip
export MPD_HOST=~/.mpd/socket

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1

for fname in ~/.bash_sources/*; do
    . $fname
done

_complete_git_co_my() {
    git branch | cut -c 3-
    git branch -r | cut -c 3-
}

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

# export SDL_AUDIODRIVER=alsa
# export PULSE_LATENCY_MSEC=60
export LIBVA_DRIVER_NAME=iHD

export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export VIRTUALENVWRAPPER_VIRTUALENV=/usr/bin/virtualenv3
export PYTHONSTARTUP="$HOME/work/python-shell-enhancement/pythonstartup.py"

export OB_TOP_MARGIN=19

. /usr/bin/virtualenvwrapper.sh

# bash vi mode
set -o vi
bind -m vi-insert '"jk": vi-movement-mode'
bind -m vi-move '"n":"Isudo "'
bind '"\e.": yank-last-arg'

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/opt/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
#         . "/opt/miniconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="/opt/miniconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# <<< conda initialize <<<

