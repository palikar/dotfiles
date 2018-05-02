DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#just copy the init file and the emacs.d in the home directory of the computer
cp $DIR/package-sources/sources.list  /etc/apt/sources.list
cp -R $DIR/package-sources/sources.list.d  /etc/apt/sources.list.d
