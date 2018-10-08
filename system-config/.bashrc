stty -ixon
shopt -s histappend
shopt -s checkwinsize
shopt -s globstar
shopt -s autocd

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

set bell-style none

source /home/arnaud/fzf/completion.bash
source /home/arnaud/fzf/key-bindings.bash

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.bash_prompt ]; then
    . ~/.bash_prompt
fi

if [ -f ~/.env ]; then
    . ~/.env
fi

if [ -f ~/.inputrc ]; then
    bind -f ~/.inputrc
fi

if [ -f ~/.paths ]; then
    ~/.scripts/pathloader
fi

if [ -n "$DISPLAY" ]; then
    xset b off
fi
