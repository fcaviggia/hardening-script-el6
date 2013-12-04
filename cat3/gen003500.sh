#!/bin/bash

## (GEN003500: CAT III) The SA will ensure core dumps are disabled or 
## restricted.
echo '==================================================='
echo ' Patching GEN003500: Disable core dumps'
echo '==================================================='

`/bin/grep core /etc/security/limits.conf | /bin/grep -q 0`
if [ $? -gt 0 ]; then
	echo "* - core 0" >> /etc/security/limits.conf
fi
