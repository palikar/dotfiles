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
echo "### Script for i3-gaps ###"
echo "##########################"

if [ $reinstall = "false" ] ; then
    autoreconf --force --install
    rm -rf build/
    mkdir -p build && cd build/
else
    echo "Reinstalling."
fi

echo "Install prefix: ${prefix}"
../configure --prefix="${prefix}" --sysconfdir=/etc --disable-sanitizers
make
sudo make install

echo "Script finished"

