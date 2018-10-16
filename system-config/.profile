export CODE_DIR="/home/arnaud/code"
export DOTFILES_DIR="${CODE_DIR}/dotfiles"
export WALLPAPER="${DOTFILES_DIR}/screens/awesome_rice.png"

export EDITOR='emacsclient -t';
export TERMINAL='rxvt-unicode';
export BROWSER="firefox";
export READER="evince"

export GOOGLE_APPLICATION_CREDENTIALS="${HOME}/.google.json"

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/snap/bin:/home/arnaud/core.d/usr/bin:$HOME/.scripts"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/arnaud/core.d/usr/lib"
export CPATH="/home/arnaud/core.d/usr/include:/usr/local/include/ni2"
. setupxkbd

addtopath () {
    if [ -f $1 ] || [ -d $1 ] ; then
        export PATH=$PATH:$1
    fi
    
}

