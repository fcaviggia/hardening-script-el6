#!/bin/sh

## (GEN000580: CAT II) (Previously – G019) The IAO will ensure all passwords contain a
## minimum of eight characters.
echo '==================================================='
echo ' Patching GEN000580: Set minimum Password length.'
echo '==================================================='
`/bin/grep PASS_MIN_LEN /etc/login.defs | /bin/grep -q 8`
if [ $? -gt 0 ]; then
	sed -i "s/PASS_MIN_LEN[ \t]*[0-9]*/PASS_MIN_LEN\t8/" /etc/login.defs
fi
