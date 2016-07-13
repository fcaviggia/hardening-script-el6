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

ARCH=`uname -i`
MY_DIR=`dirname $(realpath $0)`
BACKUP=$MY_DIR/../backups
CONFIG=$MY_DIR/../config

if [ ! -e $BACKUP ]; then 
   echo Backup directory not found.  Cannot continue.
   exit 1
fi



if [ ! -f "$BACKUP/audit.rules.orig" ]; then
	cp /etc/audit/audit.rules $BACKUP/audit.rules.orig
fi

if [ ! -f "$BACKUP/auditd.conf.orig" ]; then
	cp /etc/audit/auditd.conf $BACKUP/auditd.conf.orig
fi

#### AUDITING RULES
cp -f $CONFIG/auditd.conf /etc/audit/auditd.conf
case "$ARCH" in
	"x86_64"|"ppc64")
	cp -f $CONFIG/audit.rules /etc/audit/audit.rules
	;;
	*)
	grep -v 'b64' $CONFIG/audit.rules > /etc/audit/audit.rules
	;;
esac

# Remove RHEL 6.6 /etc/audit/rules.d directory
if [ -d /etc/audit/rules.d ]; then
	rm -rf /etc/audit/rules.d
fi

