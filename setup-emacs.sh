DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#just copy the init file and the emacs.d in the home directory of the computer
cp $DIR/.emacs  ~/.emacs -b 
cp $DIR/.emacs.d  ~/.emacs.d -b -R
