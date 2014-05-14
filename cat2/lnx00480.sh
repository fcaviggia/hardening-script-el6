#!/bin/bash

## (LNX00480: CAT II) (Previously – L204) The SA will ensure the owner of the 
## /etc/sysctl.conf file is root.
echo '==================================================='
echo ' Patching LNX00480: Set sysctl.conf owner'
echo '==================================================='
chown root /etc/sysctl.conf
