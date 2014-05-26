#!/bin/sh
#
# Script: toggle_ipv6 (part of stig-fix)
# Description: RHEL 6 Hardening Script to enbale or disable a device
# License: GPL (see COPYING)
# Copyright: Red Hat Consulting, May 2014
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

Toggles IPv6 Support on and off.
EOF
}

# APPLY SYSTEM CONFIGURATION
apply_configuration() {
    `grep ipv6 $BLACKLIST | grep -q "#"`
    if [ $? -ne 0 ]; then
		  echo -n "Enable IPv6... "
		  sed -i '/^options ipv6 disable=1/ c\#options ipv6 disable=1' $BLACKLIST
		  sed -i '/^net.ipv6.conf.all.disable_ipv6 = 1/ c\#net.ipv6.conf.all.disable_ipv6 = 0' /etc/sysctl.conf

		  `grep -q NETWORKING_IPV6 /etc/sysconfig/network`
		  if [ $? -ne 0 ]; then
        		echo "NETWORKING_IPV6=yes" >> /etc/sysconfig/network
		  else
            sed -i 's/NETWORKING_IPV6=no/NETWORKING_IPV6=yes/g' /etc/sysconfig/network
		  fi

		  `grep -q IPV6INIT /etc/sysconfig/network`
		  if [ $? -ne 0 ]; then
			    echo "IPV6INIT=yes" >> /etc/sysconfig/network
		  else
			    sed -i "/IPV6INIT/s/no/yes/" /etc/sysconfig/network
		  fi

		  for NET in $(ls /etc/sysconfig/network-scripts/ifcfg*); do
			    `grep -q IPV6INIT $NET`
			    if [ $? -ne 0 ]; then
				      echo "IPV6INIT=yes" >> $NET
			    else
				      sed -i "/IPV6INIT/s/no/yes/" $NET
			    fi
		  done

		  chkconfig --list ip6tables | grep ':on' > /dev/null
		  if [ $? -eq 0 ]; then 
        	    service ip6tables restart &>/dev/null
                chkconfig ip6tables on &>/dev/null
		  fi

		  logger "Enabled IPv6 Support (stig-fix)"
		  echo "Done."
    else
		  echo -n "Disable IPv6... "
		  sed -i '/^#options ipv6 disable=1/ c\options ipv6 disable=1' $BLACKLIST
		  sed -i '/^#net.ipv6.conf.all.disable_ipv6 = 0/ c\net.ipv6.conf.all.disable_ipv6 = 1' /etc/sysctl.conf

		  `grep -q NETWORKING_IPV6 /etc/sysconfig/network`
		  if [ $? -ne 0 ]; then
        		echo "NETWORKING_IPV6=no" >> /etc/sysconfig/network
		  else
          	    sed -i 's/NETWORKING_IPV6=yes/NETWORKING_IPV6=no/g' /etc/sysconfig/network
          fi

		  `grep -q IPV6INIT /etc/sysconfig/network`
		  if [ $? -ne 0 ]; then
			      echo "IPV6INIT=no" >> /etc/sysconfig/network
		  else
			      sed -i "/IPV6INIT/s/yes/no/" /etc/sysconfig/network
		  fi

		  for NET in $(ls /etc/sysconfig/network-scripts/ifcfg*); do
			    `grep -q IPV6INIT $NET`
			    if [ $? -ne 0 ]; then
				      echo "IPV6INIT=no" >> $NET
			    else
				      sed -i "/IPV6INIT/s/yes/no/" $NET
			    fi
		  done

		  chkconfig --list ip6tables | grep ':on' > /dev/null
		  if [ $? -eq 0 ]; then 
			    rmmod ipv6 &>/dev/null
          service ip6tables stop &>/dev/null
			    chkconfig ip6tables off &>/dev/null
		  fi

		  logger "Disabled IPv6 Support (stig-fix)"
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
echo
echo  "A reboot of the system is required to complete this process."
echo
echo -ne "\033[1mDo you want to continue?\033[0m [y/n]: "
while read a; do
	case "$a" in
		y|Y)	break;;
		n|N)	exit 0;;
		*)	echo -n "[y/n]: ";;
	esac
done
/sbin/reboot
exit 0
