#!/bin/bash

## (GEN002700: CAT I) (Previously – G095) The SA will ensure audit data files
## have permissions of 640, or more restrictive.
echo '==================================================='
echo ' Patching GEN002700: Set audit file permissions'
echo '==================================================='
chmod -R 640 /var/log/audit/*
chmod 640 /etc/audit/audit.rules
