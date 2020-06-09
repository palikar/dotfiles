###########################################
###########################################
###########################################
###   ____            _                 ###
###  | __ )  __ _ ___| |__  _ __ ___    ###
###  |  _ \ / _` / __| '_ \| '__/ __|   ###
###  | |_) | (_| \__ \ | | | | | (__    ###
###  |____/ \__,_|___/_| |_|_|  \___|   ###
###                                     ###  
###########################################
###########################################
###########################################

case $- in
    *i*) ;;
    *) return;;
esac

[ -z "$PS1" ] && return

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

if [ -f ~/.inputrc ]; then
    bind -f ~/.inputrc
fi

if [ -f ~/.config/.bash_aliases ]; then
    . ~/.config/.bash_aliases
fi

if [ -f ~/.config/.bash_prompt ]; then
    . ~/.config/.bash_prompt
fi

if [ -f ~/.config/.env ]; then
    source ~/.config/.env
fi

if [ -f ~/.config/paths ]; then
    ~/.scripts/app/pathloader
fi

if [ -f ~/code/.git-completion.bash ]; then
    source ~/code/.git-completion.bash
fi


if [ -n "$DISPLAY" ]; then
    xset b off
fi

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi


[ -f ~/.config/.fzf.bash ] && source ~/.config/.fzf.bash

# pip bash completion start
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                             COMP_CWORD=$COMP_CWORD \
                             PIP_AUTO_COMPLETE=1 $1 2>/dev/null ) )
}
complete -o default -F _pip_completion pip3
# pip bash completion end


#theming
xrdb merge "$HOME/.Xdefaults"

