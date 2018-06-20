DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

rm -f ~/.gitconfig 
ln -s $DIR/.gitconfig  ~/
