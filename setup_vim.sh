DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#just copy the init file and the emacs.d in the home directory of the computer
rm -rf ~/.vim ~/.vimrc 

ln $DIR/.vimrc ~/ -s
cp $DIR/.vim  ~/ -b -R

