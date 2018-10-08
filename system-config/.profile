export CODE_DIR=~/code
export DOTFILES_DIR=CODE_DIR/dotfiles/system-config/
export WALLPAPER="/home/arnaud/core.d/wallpapers/Future/moon_SF.jpg"

export EDITOR='emacsclient -t';
export TERMINAL='urxvt';
export BROWSER="firefox";
export READER="evince"

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/snap/bin:/home/arnaud/core.d/usr/bin:$HOME/.scripts"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/arnaud/core.d/usr/lib"
export CPATH="/home/arnaud/core.d/usr/include"

addtopath () {
    if [ -f $1 ] || [ -d $1 ] ; then
        export PATH=$PATH:$1
    fi
    
}

