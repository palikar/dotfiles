# xrdb merge "$HOME/.Xdefaults"

if [ -f ~/.config/.env ]; then
    . ~/.config/.env
fi

changepape -r

source setupxkbd

setterm -powersave off -blank 0

