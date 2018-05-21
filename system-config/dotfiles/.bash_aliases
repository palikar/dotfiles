# Shortcuts
alias reload="source ~/.bash_profile"
alias _="sudo"
alias g="git"
alias rr="rm -rf"

# List declared aliases, functions, paths
alias aliases="alias | sed 's/=.*//'"
alias paths='echo -e ${PATH//:/\\n}'

# Directory listing/traversal
alias l="ls -lahA"
alias ll="ls -lA"
alias lt="ls -lhAtr"
alias ld="ls -ld $LS_COLORS */"
alias lpm="stat -c '%a %n' *"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias -- -="cd -" 

alias tree="tree -A"
alias treed="tree -d"
alias tree1="tree -d -L 1"
alias tree2="tree -d -L 2"

# Request using GET, POST, etc. method
for METHOD in GET HEAD POST PUT DELETE TRACE OPTIONS; do
  alias "$METHOD"="lwp-request -m '$METHOD'"
done
unset METHOD

# Miscellaneous
alias hosts="sudo $EDITOR /etc/hosts"
alias his="historie"
alias quit="exit"

#Convenience things
alias week="date +%V"
alias speedtest="wget -O /dev/null http://speed.transip.nl/100mb.bin"


#Opening pdfs
alias open="gio open"

# Saving a lot of time!
alias gitcred ="git config --global credential.helper cache"


google() {
    search=""
    echo "Googling: $@"
    for term in $@; do
        search="$search%20$term"
    done
    xdg-open "http://www.google.com/search?q=$search"
}















