#!/bin/bash

## (GEN005000: CAT I) (Previously – G649) The SA will implement the anonymous 
## FTP account with a non-functional shell such as /bin/false.
echo '==================================================='
echo ' Patching GEN005000: Set shell of ftp user'
echo '==================================================='
grep ftp /etc/passwd &>/dev/null
if [ $? -eq 0 ]; then
	/usr/sbin/usermod -s /dev/null ftp
fi
