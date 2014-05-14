#!/bin/sh

## (LNX00440: CAT II) (Previously – L046) The SA will ensure /etc/login.access
## or /etc/security/access.conf file will be 640, or more restrictive.
echo '==================================================='
echo ' Patching LNX00440: Set access.conf permissions'
echo '==================================================='
chmod 640 /etc/security/access.conf
