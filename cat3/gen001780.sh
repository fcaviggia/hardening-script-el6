#!/bin/bash

## (GEN001780: CAT III) (Previously – G112) The SA will ensure global 
## initialization files contain the command mesg –n.
echo '==================================================='
echo ' Patching GEN001780: Add mesg -n to global'
echo '                     initialization files'
echo '==================================================='
for FILE in /etc/{profile,bashrc}; do
	`/bin/grep -q mesg $FILE`
	if [ $? -gt 0 ]; then
		echo "mesg n" >> $FILE
	fi
done;
