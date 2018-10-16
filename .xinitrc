# Disable access control
xhost +SI:localuser:$USER

start-pulseaudio-x11


# Make Java applications aware this is a non-reparenting window manager.
export _JAVA_AWT_WM_NONREPARENTING=1

# Themes, etc
gnome-settings-daemon &

# Fallback cursor
xsetroot -cursor_name left_ptr

# Keyboard repeat rate
xset r rate 200 60

xset dpms 0 0 0
xset -dpms
xset s off
setterm -balnk 0

setxkbmap -layout de,bg -variant "deadacute, phonetic"
setxkbmap -option caps:ctrl_modifier
