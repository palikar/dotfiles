#!/bin/bash



usage() { echo "Usage: $0 [-r] [-p preffix]" 1>&2; exit 1; }

while getopts ":rp:" o; do
    case "${o}" in
        r) reinstall=true;;
        p) prefix=${OPTARG};;
        *) usage;;
    esac
done
shift $((OPTIND-1))


[ -z ${reinstall+x} ] && reinstall=false
[ -z ${prefix+x} ] && prefix="/usr/local"

echo "##########################"
echo "### Script for Emacs ###"
echo "##########################"

echo "Install prefix: ${prefix}"

CFLAGS="-g3 -O3" ./configure --with-x  --with-xwidgets --with-mailutils --with-pop --prefix="${prefix}"
make -j4
sudo make install

echo "Script finished"
