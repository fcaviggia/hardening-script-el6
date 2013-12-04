#!/bin/sh

## (LNX00320: CAT I) (Previously – L140) The SA will delete accounts that
## provide a special privilege such as shutdown and halt.
echo '==================================================='
echo ' Patching LNX00320: Deleting accounts providing'
echo '                    special privilege.'
echo '==================================================='

`grep -q shutdown /etc/passwd`
if [ $? -eq 0 ]; then
	/usr/sbin/userdel shutdown
fi

`grep -q halt /etc/passwd`
if [ $? -eq 0 ]; then
	/usr/sbin/userdel halt
fi

`grep -q sync /etc/passwd`
if [ $? -eq 0 ]; then
	/usr/sbin/userdel sync
fi
