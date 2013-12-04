#!/bin/bash

## (GEN003240: CAT II) (Previously – G622) The SA will ensure the owner and 
## group owner of the cron.allow file is root.
echo '==================================================='
echo ' Patching GEN003240: Set owner and group owner of' 
echo '                     the cron.allow file'
echo '==================================================='
chown root:root /etc/cron.allow
