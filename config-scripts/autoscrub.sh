#!/bin/bash

# Determine the Path
function realpath() {
    local r=$1; local t=$(readlink $r)
    while [ $t ]; do
        r=$(cd $(dirname $r) && cd $(dirname $t) && pwd -P)/$(basename $t)
        t=$(readlink $r)
    done
    echo $r
}

MY_DIR=`dirname $(realpath $0)`
CONFIG=$MY_DIR/../config


#### CLEAN TEMP FILES ON REBOOT WITH SCRUB (Server, Workstation)
rpm -q scrub &>/dev/null
if [ $? -eq 0 ]; then
	cp $CONFIG/clean_system /etc/init.d/clean_system
	chmod +x /etc/init.d/clean_system
	/sbin/chkconfig --add clean_system
	/sbin/chkconfig --level 06 clean_system on
	/sbin/chkconfig --level 12345 clean_system off
else
	if [ -z "$QUIET" ]; then
		echo
		echo "Scrub not installed. Secure /tmp and /var/tmp wipe service not installed." | tee -a $LOG
	else
		echo
		echo "Scrub not installed. Secure /tmp and /var/tmp wipe service not installed." >> $LOG
	fi
fi

