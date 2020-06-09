#!/bin/bash

SCRIPTDIR=$(dirname "$(readlink -f "$0")")
DIR=$SCRIPTDIR/..

CODE="$HOME/code"

create_home_dirs()
{
    while IFS='' read -r line || [[ -n "$folder" ]]; do
        echo "Creating '$HOME/$line'"
        [ -d $HOME/$folder ] || mkdir -p $HOME/$folder
    done < $SCRIPTDIR/folders
}

install_deb_packages()
{

    sudo apt-get update

    for pack in $(cat "$SCRIPTDIR/apt_packages"); do

        echo "Installing '$pack'"

        [ dpkg -s "$pack"] && sudo apt-get install -y --force-yes $pack
        
        sleep 1

    done

    echo "Updating and upgrading packages"
    sudo apt-get update -y --force-yes
    sudo apt-get upgrade -y --force-yes

    echo "Removing unnecessary packages"
    sudo apt autoremove -y --force-yes

}

install_python_packages()
{
    
    for pack in $(cat "$SCRIPTDIR/python_packages"); do
        sleep 1
        echo "Installing $pack"
        pip3 install $pack --user
        sleep 1
    done
    
}

setup_files()
{
    echo "Setting up dot files and other configuration files "

    [ -d "${HOME}/.config" ] && mv "${HOME}/.config" "${HOME}/.config_old"
    ln -s "${DIR}/.config" "${HOME}/.config"

    [ -d "${HOME}/.scripts" ] && rm -rf "${HOME}/.scripts"
    ln -s "${DIR}/.scripts" "${HOME}/.scripts"

    for dot in $(ls "${DIR}/system-config" -A); do
        [ -f "${HOME}/$dot" ] && rm -f "${HOME}/$dot"
        ln -s "${DIR}/system-config/${dot}" "${HOME}/.config/$dot"
    done

    for dot in $(ls "${DIR}/home_dots" -A); do
        [ -f "${HOME}/$dot" ] && rm -f "${HOME}/$dot"
        ln -s "${DIR}/home_dots/${dot}" "${HOME}/$dot"
    done
    

    # emascs ####################
    cp "$DIR/.emacs.d"  "${HOME}/" -b -R

    rm -f "${HOME}/.emacs.d/myinit.org"
    rm -f "${HOME}/.emacs.d/init.el"
    rm -rf "${HOME}/.emacs.d/snippets"

    ln -s "$DIR/.emacs.d/myinit.org" "${HOME}/.emacs.d/myinit.org"
    ln -s "$DIR/.emacs.d/init.el" "${HOME}/.emacs.d/init.el"
    ln -s "$DIR/.emacs.d/snippets" "${HOME}/.emacs.d/snippets"
    ##############################

}


set_package_sources()
{
    echo "Setting up the package sources.."
    [ -f "/etc/apt/sources.list" ] && sudo rm       "/etc/apt/sources.list"
    sudo ln -s $DIR/package-sources/sources.list    "/etc/apt/sources.list"
}

# Integrity checks
[ -f $SCRIPTDIR/apt_packages ] || (echo "The apt packages file is not there!" && exit 1)
[ -f $SCRIPTDIR/python_packages ] || (echo "The python packages file is not there!" && exit 1)
[ -f $SCRIPTDIR/folders ] || ( echo "The folders file is not there!" && exit 1)
[ -f $SCRIPTDIR/codes ] || ( echo "The codes file is not there!" && exit 1)


# Setup basic system

###########################################
###### The installation begins # ##########
###########################################

create_home_dirs

set_package_sources

install_deb_packages

install_python_packages


# Setup basic application

setup_files

source "${HOME}/.profile"

source "${HOME}/.bashrc"


###########################################
###### The installation is ready ##########
###########################################

echo "Let the games begin!"
