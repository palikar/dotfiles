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
echo "### Script for  urxvt  ###"
echo "##########################"

if [ $reinstall = "false" ] ; then
    tar -xvf rxvt-unicode-*.tar.bz2 --strip 1
else
    echo "Reinstalling."
fi

echo "Install prefix: ${prefix}"
CFLAGS="-g3 -O3" ./configure  --enable-everything --enable-256-color --prefix=$prefix --enable-perl=/usr/bin/perl5.30.2
make -j4
sudo make install

echo "Script finished"

