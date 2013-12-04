#!/bin/bash

## (GEN001460: CAT IV) (Previously – G052) The SA will ensure all home 
## directories defined in the /etc/passwd file exist.
echo '==================================================='
echo ' Patching GEN001460: Create home directories'
echo '==================================================='
for HOMEDIR in `cut -d: -f6 /etc/passwd`; do
	if [ ! -d $HOMEDIR ]; then
		if [ $HOMEDIR != '/dev/null' ]; then
			mkdir $HOMEDIR
		fi
	fi
done;
