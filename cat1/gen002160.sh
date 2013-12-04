#!/bin/bash

## (GEN002160: CAT I) (Previously – G072) The SA will ensure no shell has the 
## suid bit set.
echo '==================================================='
echo ' Patching GEN002160: No shells have suid bit set'
echo '==================================================='
for SHELL in `cat /etc/shells`; do
	if [ -x $SHELL ]; then
		chmod u-s $SHELL
	fi
done
