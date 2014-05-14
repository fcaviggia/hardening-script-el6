#!/bin/bash

## Set Account Expiration Following Inactivity
## INACTIVE must be set to 35 to meet STIG requirements
echo '==================================================='
echo ' Modify /etc/defulat/useradd for Inactive Users'
echo '==================================================='
grep -q ^INACTIVE /etc/default/useradd && \
	sed -i "s/INACTIVE.*/INACTIVE=35/g" /etc/default/useradd
if ! [ $? -eq 0 ]; then
	echo "INACTIVE=35" >> /etc/default/useradd
fi
