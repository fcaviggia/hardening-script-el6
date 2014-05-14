#!/bin/bash

## (GEN006140: CAT II) (Previously – L052) The SA will ensure the
## /etc/samba/smb.conf file has permissions of 644, or more restrictive.
echo '==================================================='
echo ' Patching GEN006140: Set permissions of smb.conf'
echo '==================================================='
if [ -e /etc/samba/smb.conf ]; then
	chmod 644 /etc/samba/smb.conf
fi
