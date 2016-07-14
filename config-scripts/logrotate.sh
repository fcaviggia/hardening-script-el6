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

if [ ! -f "$BACKUP/logrotate.orig" ]; then
	cp /etc/logrotate.conf $BACKUP/logrotate.conf.orig
fi

##### LOGROTATE (DAILY)
cp -f $CONFIG/logrotate.conf /etc/logrotate.conf

