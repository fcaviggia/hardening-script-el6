#!/bin/sh

## (GEN003520: CAT III) The SA will ensure the owner and group owner of the
## core dump  data directory is root with permissions of 700, or more
## restrictive.
echo '==================================================='
echo ' Patching GEN003520: Set crash log dir permissions'
echo '==================================================='
if [ -e /var/crash ]; then
	chown root:root /var/crash
	chmod -R 700 /var/crash
fi
