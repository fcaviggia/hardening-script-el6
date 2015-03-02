#!/bin/sh
#
# Script: toggle_usb (part of system-hardening)
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
KERNEL_MODULE="/lib/modules/$KERNEL/kernel/drivers/usb/storage/usb-storage.ko"

# USAGE STATEMENT
usage() {
cat << EOF
usage: $0 [options]

  -h 	Show this message

RHEL 6 Hardening Script

Toggles USB Mass Storage Support on and off.
EOF
}

# APPLY SYSTEM CONFIGURATION
apply_configuration() {
	if [ ! -e $BASE_BACKUP/usb-storage.ko.$KERNEL ]; then
		cp $KERNEL_MODULE $BASE_BACKUP/usb-storage.ko.$KERNEL
	fi
	echo -ne "\033[1mDo you have security approval to connect a USB device?\033[0m [y/n]: "
	while read a; do
		case "$a" in
		y|Y)	break;;
		n|N)	exit 2;;
		*)	echo -n "[y/n]: ";;
		esac
	done
	echo -n "Enable USB Mass Storage Driver... "
	
	if [ -e $BASE_BACKUP/usb-storage.ko.$KERNEL ]; then
		cp $BASE_BACKUP/usb-storage.ko.$KERNEL $KERNEL_MODULE
	fi

	if [ -f $BLACKLIST ]; then
		grep -q usb-storage $BLACKLIST 
		if [ $? -eq 0 ]; then
			sed -i '/^install usb-storage \/bin\/false/ c\#install usb-storage \/bin\/false' $BLACKLIST
		fi
	fi
	/usr/bin/logger -p security.info "Enabled USB Mass Storage Module (system-hardening)"
	echo "Done."

}
# RESTORE ORIGINAL CONFIGURATION
remove_configuration() {
	if [ ! -e $BASE_BACKUP/usb-storage.ko.$KERNEL ]; then
		cp $KERNEL_MODULE $BASE_BACKUP/usb-storage.ko.$KERNEL
	fi
	echo -n "Disable USB Mass Storage Driver... "
	rm -f $KERNEL_MODULE
	if [ -f $BLACKLIST ]; then
		grep -q usb-storage $BLACKLIST
		if [ $? -eq 0 ]; then
			sed -i '/^#install usb-storage \/bin\/false/ c\install usb-storage \/bin\/false' $BLACKLIST
			/sbin/lsmod | grep -q usb_storage
			if [ $? -eq 0 ]; then
				/sbin/rmmod usb_storage
			fi
		fi
	fi
	/usr/bin/logger -p security.info "Disabled USB Mass Storage Module (system-hardening) by."
	echo "Done."
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


if [ -e $KERNEL_MODULE ]; then
	remove_configuration
else
	apply_configuration
fi

exit 0
