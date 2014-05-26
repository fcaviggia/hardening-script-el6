#!/bin/sh
#
# Script: toggle_udf (part of stig-fix)
# Description: RHEL 6 Hardening Script to enbale or disable a device
# License: GPL (see COPYING)
# Copyright: Red Hat Consulting, Sep 2013
# Author: Frank Caviggia <fcaviggi (at) redhat.com>

# Determine the Path
function realpath() {
    local r=$1; local t=$(readlink $r)
    while [ $t ]; do
        r=$(cd $(dirname $r) && cd $(dirname $t) && pwd -P)/$(basename $t)
        t=$(readlink $r)
    done
echo $r
}

# GLOBAL VARIABLES
BASE_DIR=`dirname $(realpath $0)`
BASE_BACKUP=$BASE_DIR/backups
KERNEL=`uname -r`
BLACKLIST="/etc/modprobe.d/usgcb-blacklist.conf"

# USAGE STATEMENT
usage() {
cat << EOF
usage: $0 [options]

  -h 	Show this message

RHEL 6 Hardening Script

Toggles udf (DVD) Support on and off.
EOF
}

# APPLY SYSTEM CONFIGURATION
apply_configuration() {
	grep udf $BLACKLIST | grep -q "#"
	if [ $? -ne 0 ]; then
		echo -n "Enable udf (DVD) filesystem... "
		sed -i '/^install udf \/bin\/false/ c\#install udf \/bin\/flase' $BLACKLIST
		logger "Enabled UDF/DVD Support (stig-fix)"
		echo "Done."
	else
		echo -n "Disable udf (DVD) file system... "
		sed -i '/^#install udf \/bin\/false/ c\install udf \/bin\/false' $BLACKLIST
		logger "Disabled UDF/DVD Support (stig-fix)"
		echo "Done."
	fi
}


# Check for root user
if [[ $EUID -ne 0 ]]; then
	if [ -z "$QUIET" ]; then
		echo
		tput setaf 1;echo -e "\033[1mPlease re-run this script as root!\033[0m";tput sgr0
	fi
	exit 1
fi

while getopts ":h" OPTION; do
	case $OPTION in
		h)
			usage
			exit 0
			;;
		?)
			echo "ERROR: Invalid Option Provided!"
			echo
			usage
			exit 1
			;;
	esac
done

apply_configuration

exit 0
