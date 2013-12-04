#!/bin/bash

## (GEN003040: CAT II) The SA will ensure the owner of crontabs is root or the 
## crontab creator.
echo '==================================================='
echo ' Patching GEN003040: Set owner of crontabs to root'
echo '==================================================='
chown -R root /etc/cron.*
chown -R root /var/spool/cron/
