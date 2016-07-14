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
BACKUP=$MY_DIR/../backups
CONFIG=$MY_DIR/../config

if [ ! -e $BACKUP ]; then 
   echo Backup directory not found.  Cannot continue.
   exit 1
fi

if [ ! -f "$BACKUP/sshd_config.orig" ]; then
	cp /etc/ssh/sshd_config $BACKUP/sshd_config.orig
fi


#### SSH CONIFIGURATION
cp -f $CONFIG/sshd_config /etc/ssh/sshd_config
`ls /etc/ssh/ssh_host_* | grep -q key`
if [ $? -ne 0 ]; then
	/etc/init.d/sshd restart &> /dev/null
fi
