#!/bin/sh

## (GEN001260: CAT II) (Previously – G037) The SA will ensure all system log
## files have permissions of 640, or more restrictive.

## Note:  This script has been split into two parts for systems
##        where it's desired to change log file permissions without
##        altering rc.sysinit. Part two isn't required per stig since
##        /var/log/wtmp is not referenced from rsyslog.conf

echo '==================================================='
echo ' Patching GEN001260: Setting permissions of system'
echo '                     log files.'
echo '==================================================='
find /var/log/ -type f -exec chmod 600 '{}' \;
