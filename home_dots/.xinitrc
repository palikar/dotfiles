# Disable access control
xhost +SI:localuser:$USER

start-pulseaudio-x11

# Fallback cursor
xsetroot -cursor_name left_ptr

# Keyboard repeat rate
xset r rate 230 35

xset s off
xset -dpms
setterm -blank 0 -powersave off -powerdown 0

setxkbmap -layout de,bg -variant "deadacute, phonetic"
setxkbmap -option caps:ctrl_modifier

exec i3

[[ -f ~/.Xdefaults ]] && xrdb -merge -I$HOME ~/.Xdefaults
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
