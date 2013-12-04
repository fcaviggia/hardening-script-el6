#!/bin/bash

## (GEN002040: CAT I) The SA will ensure .rhosts, .shosts, hosts.equiv, nor
## shosts.equiv are used, unless justified and documented with the IAO.
echo '==================================================='
echo ' Patching GEN002040: Remove .rhosts, .shosts,'
echo '                     hosts.equiv, and shosts.equiv'
echo '==================================================='
for file in /root/.rhosts /root/.shosts /etc/hosts.equiv
do
	rm -f $file
	ln -s /dev/null $file
done
