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

if [ ! -f "$BACKUP/hosts.allow.orig" ]; then
	cp /etc/hosts.allow $BACKUP/hosts.allow.orig
fi

if [ ! -f "$BACKUP/hosts.deny.orig" ]; then
	cp /etc/hosts.deny $BACKUP/hosts.deny.orig
fi

#### TCP_WRAPPERS CONFIGURATIONS (was GEN006620)
cp -f $CONFIG/hosts.allow /etc/hosts.allow
cp -f $CONFIG/hosts.deny /etc/hosts.deny

