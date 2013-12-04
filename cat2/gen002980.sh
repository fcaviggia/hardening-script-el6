#!/bin/bash

## (GEN002980: CAT II) (Previously – G201) The SA will ensure the cron.allow 
## file has permissions of 600, or more restrictive.
echo '==================================================='
echo ' Patching GEN002980: Set permissions of cron.allow'
echo '==================================================='
touch /etc/cron.allow
chmod 600 /etc/cron.allow
