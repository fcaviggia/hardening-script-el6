#!/bin/bash

## (LNX00400: CAT II) (Previously – L044) The SA will ensure the owner of the
## /etc/login.access or /etc/security/access.conf file is root.
echo '==================================================='
echo ' Patching LNX00400: Set access.conf owner'
echo '==================================================='
chown root /etc/security/access.conf
