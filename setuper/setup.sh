#!/bin/bash


SCRIPTDIR=$(dirname "$(readlink -f "$0")")
DIR=$SCRIPTDIR/..

CODE="$HOME/code"
CODE_EXT="$HOME/code_ext"
CODE_SYS="$HOME/code_sys"


create_home_dirs()
{
	while IFS='' read -r line || [[ -n "$folder" ]]; do
		echo "Creating '$HOME/$folder'"
		[ -d $HOME/$folder ] || mkdir $HOME/$folder
	done < $SCRIPTDIR/folders
}

install_deb_packages()
{
	sudo apt-get update
	
	for pack in $(cat "$SCRIPTDIR/apt_packages"); do
		sudo apt-get install -y --force-yes $pack
	done

	sudo apt-get update -y --force-yes
	sudo apt-get upgrade -y --force-yes
	sudo apt-get update -y --force-yes
	sudo apt autoremove
}

install_python_packages()
{
	for pack in $(cat "$SCRIPTDIR/python_packages"); do
        pip3 install $pack --user
    done
}

pull_all()
{
	cd $1

	for repo in $(cat "$2"); do
        $(git pull "$repo" 2> /dev/null) || echo "$repo is already there"
	done

	cd ~
}

set_package_sources()
{
    sudo rm /etc/apt/sources.list
    sudo rm -rf /etc/apt/sources.list.d
    ln -s $DIR/package-sources/sources.list  /etc/apt/sources.list
    ln -s $DIR/package-sources/sources.list.d  /etc/apt/sources.list.d
}

setup_files()
{

	[ -d "${HOME}/.config" ] && mv "${HOME}/.config" "${HOME}/.config_old"
	ln -s "${DIR}/.config" "${HOME}/.config"

	[ -d "${HOME}/.scripts" ] && rm -rf "${HOME}/.scripts"
	ln -s "${DIR}/.scripts" "${HOME}/.scripts"

	for dot in $(ls "${DIR}/system-config"); do
		[ -f "${HOME}/$dot" ] && rm "${HOME}/$dot"
		ln -s "${DIR}/$dot" "${HOME}/$dot"
	done

	[ -f "${HOME}/.gitconfig" ] && rm "${HOME}/.gitconfig"
	ln -s "${DIR}/.gitconfig" "${HOME}/.gitconfig"

	[ -f "${HOME}/.xinitrc" ] && rm "${HOME}/.xinitrc" 
	ln -s "$DIR/.xinitrc" "${HOME}/.xinitrc"

	[ -f "${HOME}/.Xdefaults" ] && rm "${HOME}/.Xdefaults" 
	ln -s "$DIR/.Xdefaults" "${HOME}/.Xdefaults"

	[ -f "${HOME}/.paths" ] && rm "${HOME}/.paths" 
	ln -s "$DIR/.paths" "${HOME}/.paths"

	cp "$DIR/.emacs.d"  "${HOME}/" -b -R
	rm -f "${HOME}/.emacs.d/myinit.org"
	rm -f "${HOME}/.emacs.d/init.el"
	ln -s "$DIR/.emacs.d/myinit.org" "${HOME}/.emacs.d/myinit.org"
	ln -s "$DIR/.emacs.d/init.el" "${HOME}/.emacs.d/init.el"

	[ -d "${HOME}/.urxvt-perls" ] && rm "${HOME}/.urxvt-perls" 
	ln -s "$DIR/urxvt-perls" "${HOME}/.urxvt-perls"	

}

setup_vim()
{
	[ -d "$HOME/.vim_runtime" ] || rm -rf "$HOME/.vim_runtime"
	git clone --depth=1 https://github.com/amix/vimrc.git "$HOME/.vim_runtime"
	sh ~/.vim_runtime/install_awesome_vimrc.sh
}

setup_fzf()
{
	[-d "$HOME/.fzf" ] || rm -rf "$HOME/.fzf"
	git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
	$HOME/.fzf/install --key-bindings --no-completion --update-rc
}

setup_emacs()
{
	cd $CODE_EXT
	wget "https://ftp.gnu.org/gnu/emacs/emacs-26.1.tar.gz"
	tar zxvf "emacs-26.1.tar.gz"
	cd ./emacs-26.1
	autoreconf --force --install
	export CFLAGS="-g3 -O3" && ./configure --with-x  --with-xwidgets --with-mailutils --with-pop
	make -j4 && sudo make install
	cd $HOME
}

setup_i3()
{
	cd $CODE_EXT
	cd ./i3
	autoreconf --force --install
	[ -d ./build ] && rm -rf build/
	mkdir -p build && cd build/
	echo "$(pwd)"
	export CFLAGS="-g3 -O3"
	../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
	make -j4 && sudo make install
	cd $HOME
}

setup_urxvt()
{
	cd $CODE_EXT
	wget "http://dist.schmorp.de/rxvt-unicode/Attic/rxvt-unicode-9.22.tar.bz2"
	tar jxvf "rxvt-unicode-9.22.tar.bz2"
	cd ./rxvt-unicode-9.22
	autoreconf --force --install
	export CFLAGS="-g3 -O3" &&   ./configure --enable-everything --enable-256-color --prefix=/usr
	make -j4 && sudo make install
	cd $HOME
}

setup_dropbox()
{
	cd $HOME/Downloads/
	wget -O "dropbox.deb" "https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2019.01.31_amd64.deb"
	sudo dpkg -i "dropbox.deb"
	sudo apt-get -f install
	cd $HOME
}

setup_discrod()
{
	wget -O "discord.deb" "https://discordapp.com/api/download?platform=linux&format=deb"
	sudo dpkg -i "discord.deb"
	sudo apt-get -f install
	cd $HOME

}

[ -f $SCRIPTDIR/apt_packages ] || (echo "The apt packages file is not there!" && exit 1)
[ -f $SCRIPTDIR/python_packages ] || (echo "The python packages file is not there!" && exit 1)
[ -f $SCRIPTDIR/folders ] || ( echo "The folders file is not there!" && exit 1)
[ -f $SCRIPTDIR/sys_codes ] || ( echo "The system codes folders file is not there!" && exit 1)
[ -f $SCRIPTDIR/ext_codes ] || ( echo "The external codes file is not there!" && exit 1)
[ -f $SCRIPTDIR/codes ] || ( echo "The codes file is not there!" && exit 1)


# Setup basic system

create_home_dirs

set_package_sources

install_deb_packages

install_python_packages


# Setup basic application

setup_files

setup_vim

setup_fzf

# Pull repos from github

pull_all $CODE "$SCRIPTDIR/codes"

pull_all $CODE_EXT "$SCRIPTDIR/ext_codes"

pull_all $CODE "$SCRIPTDIR/sys_codes"


# Setup essenital applications

setup_i3

setup_urxvt

setup_emacs

setup_dropbox

setup_discrod


source "${HOME}/.profile"
source "${HOME}/.bashrc"




