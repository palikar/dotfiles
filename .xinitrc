# Disable access control
xhost +SI:localuser:$USER

start-pulseaudio-x11

# Make Java applications aware this is a non-reparenting window manager.
export _JAVA_AWT_WM_NONREPARENTING=1

# Fallback cursor
xsetroot -cursor_name left_ptr

# Keyboard repeat rate
xset r rate 230 35

xset s off
xset -dpms
setterm -blank 0 -powersave off -powerdown 0

setxkbmap -layout de,bg -variant "deadacute, phonetic"
setxkbmap -option caps:ctrl_modifier

