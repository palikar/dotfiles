DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#just copy the init file and the emacs.d in the home directory of the computer


ln $DIR/.emacs  ~/.emacs -s 
cp $DIR/.emacs.d  ~/ -b -R
rm -f ~/.emacs.d/myinit.org
ln $DIR/.emacs.d/myinit.org /.emacs.d/myinit.org -s 

