DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


rm -f ~/.bash_aliases 
rm -f ~/.bash_logout 
rm -f ~/.bash_prompt 
rm -f ~/.inputrc 
rm -f ~/.env
rm -f ~/.bashrc 

ln -s $DIR/system-config/.bash_aliases ~/
ln -s $DIR/system-config/.bash_logout ~/
ln -s $DIR/system-config/.bash_prompt ~/
ln -s $DIR/system-config/.inputrc ~/
ln -s $DIR/system-config/.env ~/
ln -s $DIR/system-config/.bashrc ~/

. ~/.bashrc
