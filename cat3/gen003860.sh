#!/bin/bash

## (GEN003860: CAT III) (Previously – V046) The SA will ensure finger is not
## enabled.
echo '==================================================='
echo ' Patching GEN003860: Disable finger daemon'
echo '==================================================='

`/sbin/chkconfig --list | grep -q finger`
if [ $? -gt 0 ]; then
	/sbin/chkconfig finger off 2>/dev/null
fi
