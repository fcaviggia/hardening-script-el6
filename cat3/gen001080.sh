#!/bin/bash

## (GEN001080: CAT III) (Previously – G229) The SA will ensure the root shell 
## is not located in /usr if /usr is partitioned.
echo '==================================================='
echo ' Patching GEN001080: Set root shell out of /usr'
echo '==================================================='
grep root /etc/passwd | grep -q bash 2>/dev/null
if [ $? -ne 0 ]; then
	/usr/sbin/usermod -s /bin/bash root
fi
