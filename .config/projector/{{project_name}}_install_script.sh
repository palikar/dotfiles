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

echo "###########################"
echo " Script for {{project_name}} "
echo "###########################"
echo "Install prefix: ${prefix}"


if [ $reinstall = "false" ] ; then
    # Installation here
    echo "Installing."
else
    # Reinstallation here
    echo "Reinstalling."
fi

echo "Script finished"
