#!/bin/sh
echo '==================================================='
echo ' Patching GEN001210: Remove ACLs on System Files'
echo '==================================================='

for CHKDIR in '/etc /bin /usr/bin /usr/lbin /usr/usb /sbin /usr/sbin'; do
	if [ -d "$CHKDIR" ];  then
    		for FILENAME in `find $CHKDIR ! -type l`; do
			if [ -e "$FILENAME" ]; then
        			ACLOUT=`getfacl --skip-base $FILENAME 2>/dev/null`;
        			if [ "$ACLOUT" != "" ]; then
					setfacl --remove-all $FILENAME
        			fi
      			fi
    		done
  	fi
done
