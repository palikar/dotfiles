

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
    PATH="snap/bin:$PATH"	
fi


#load all of the dotfiles for the system config
for DOTFILE in `find ~/code/dotfiles/system-config/dotfiles`
do
  [ -f “$DOTFILE” ] && source “$DOTFILE”
done



