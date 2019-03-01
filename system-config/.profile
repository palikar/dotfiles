
if [ -f ~/.env ]; then
    . ~/.env
fi


. setupxkbd

addtopath () {
    if [ -f $1 ] || [ -d $1 ] ; then
        export PATH=$PATH:$1
    fi
    
}

