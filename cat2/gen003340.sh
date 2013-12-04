#!/bin/bash

## (GEN003340: CAT II) (Previously – G214) The SA will ensure the at.allow and 
## at.deny files have permissions of 600, or more restrictive.
echo '==================================================='
echo ' Patching GEN003340: Set permissions of at.allow '
echo '                     and at.deny files'
echo '==================================================='
chmod 600 /etc/at.allow
chmod 600 /etc/at.deny
