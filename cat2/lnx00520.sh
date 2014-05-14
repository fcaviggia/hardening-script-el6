#!/bin/sh

## (LNX00520: CAT II) (Previously – L208) The SA will ensure the
## /etc/sysctl.conf file has permissions of 600, or more restrictive.
echo '==================================================='
echo ' Patching LNX00520: Set sysctl.conf permission'
echo '==================================================='
chmod 600 /etc/sysctl.conf
