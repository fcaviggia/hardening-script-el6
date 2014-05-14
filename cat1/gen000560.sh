#!/bin/bash

## (GEN000560: CAT I) (Previously – G018) The SA will ensure each account in 
## the /etc/passwd file has a password assigned or is disabled in the 
## password, shadow, or equivalent, file by disabling the password and/or by 
## assigning a false shell in the password file.
echo '==================================================='
echo ' Patching GEN000560: Disable accounts with no'
echo '                     password'
echo '==================================================='
for USERINFO in `cat /etc/shadow`; do
	if [ -z "`echo $USERINFO | cut -d: -f2`" ]; then
		/usr/sbin/usermod -L -s /dev/null `echo $USERINFO | cut -d: -f1` 
	fi
done;
