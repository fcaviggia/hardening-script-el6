#!/bin/sh

## (GEN001260: CAT II) (Previously – G037) The SA will ensure all system log
## files have permissions of 640, or more restrictive.
##
## Note - this script has been split into two parts
##
echo '==================================================='
echo ' Patching GEN001260: Setting permissions of system'
echo '                     log files, part 2.'
echo '==================================================='
sed -i "s/chmod 0664/chmod 0600/" /etc/rc.d/rc.sysinit
