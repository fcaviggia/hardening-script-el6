#!/bin/bash

## Set Account Expiration Following Inactivity
## INACTIVE must be set to 35 to meet STIG requirements

grep -q ^INACTIVE /etc/default/useradd && \
	sed -i "s/INACTIVE.*/INACTIVE=35/g" /etc/default/useradd
if ! [ $? -eq 0 ]; then
	echo "INACTIVE=35" >> /etc/default/useradd
fi
