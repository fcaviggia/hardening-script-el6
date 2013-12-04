#!/bin/bash

## (GEN004580: CAT I) (Previously – G647) The SA will ensure .forward files 
## are not used.
echo '==================================================='
echo ' Patching GEN004580: Remove any .forward files'
echo '==================================================='
for HOMEDIR in `cut -d: -f6 /etc/passwd`; do
	if [ -f $HOMEDIR/.forward ]; then
		rm $HOMEDIR/.forward
	fi
done;
