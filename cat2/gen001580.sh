#!/bin/bash

## (GEN001580: CAT II) (Previously – G058) The SA will ensure run control 
## scripts have permissions of 755, or more restrictive.
echo '==================================================='
echo ' Patching GEN001580: Set permissions of run control'
echo '                     scripts'
echo '==================================================='
chmod 755 /etc/rc.d/init.d/*
