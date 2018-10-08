


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


set_package_sources() {
    rm /etc/apt/sources.list
    rm -rf /etc/apt/sources.list.d
    ln -s $DIR/package-sources/sources.list  /etc/apt/sources.list
    ln -s $DIR/package-sources/sources.list.d  /etc/apt/sources.list.d

}

set_dot_files() {

    for dot in $(ls "${DIR}/system-config"); do
        rm "${HOME}/$dot"
        ln -s "${DIR}/$dot" "${HOME}/$dot"
    done
    
    rm "${HOME}.gitconfig"
    ln -s "${DIR}/.gitconfig" "${HOME}.gitconfig"

    rm -rf ~/.vim ~/.vimrc
    ln -s "$DIR/.vimrc" "${HOME}/.vimrc"
    cp $DIR/.vim  ${HOME} -b -R

    rm "${HOME}/.xinitrc" 
    ln -s "$DIR/.xinitrc" "${HOME}/.xinitrc"
    
    rm "${HOME}/.Xdefaults" 
    ln -s "$DIR/.Xdefaults" "${HOME}/.Xdefaults"

    rm "${HOME}/.paths" 
    ln -s "$DIR/.paths" "${HOME}/.paths"

    ln -s "$DIR/.emacs" "${HOME}/.emacs"
    cp "$DIR/.emacs.d"  "${HOME}/" -b -R
    rm -f "${HOME}/.emacs.d/myinit.org"
    ln -s "$DIR/.emacs.d/myinit.org" "${HOME}/.emacs.d/myinit.org"

    rm "${HOME}/.urxvt-perls" 
    ln -s "$DIR/urxvt-perls" "${HOME}/.urxvt-perls"
}

set_config_dir() {
    if [ -d "${HOME}/.config" ] ; then
        mv "${HOME}/.config" "${HOME}/.config_old"
    fi
    ln -s "${DIR}/.config" "${HOME}/.config"

    rm -rf "${HOME}/.scripts"
    ln -s "${DIR}/.scripts" "${HOME}/.scripts"    
}


install_apt_packages() {

    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get update
    
    for pack in $(cat "${DIR}/apt_packages.txt"); do
        sudo apt-get install -y --force-yes $pack
    done
    
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get update
    sudo apt autoremove
    
}

serviceinit(){
    for service in "$@"; do
        echo "Enabling service: ${service}" 
        systemctl enable "$service"
        systemctl start "$service"
    done ;
}

set_package_sources

set_dot_files

set_config_dir

# install_apt_packages



source "${DIR}/.profile"
source "${DIR}/.bashrc"

if ! [ -d "${HOME}/code" ];
then 
    mkdir -p  "${HOME}/code"
fi


