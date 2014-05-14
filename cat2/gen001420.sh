#!/bin/bash

## (GEN001420: CAT II) (Previously – G050) The SA will ensure the /etc/shadow 
## file (or equivalent) has permissions of 400.
echo '==================================================='
echo ' Patching GEN001420: Set permissions of /etc/shadow'
echo '==================================================='
chmod 0000 /etc/shadow
