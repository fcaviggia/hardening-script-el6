#!/bin/sh

echo '==================================================='
echo ' Patching GEN000950: Remove LD_PRELOAD for Root User'
echo '==================================================='

ROOTDIR=`cat /etc/passwd | grep -i ^root | cut -d ":" -f 6`

for CONFIG in `find $ROOTDIR -name .bash_profile -print`; do
	sed -i '/LD_PRELOAD/d' $CONFIG
done
