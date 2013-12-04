#!/bin/bash

## (GEN001400: CAT I) (Previously – G047) The SA will ensure the owner of the 
## /etc/passwd and /etc/shadow files (or equivalent) is root.
echo '==================================================='
echo ' Patching GEN001400: Set owner of /etc/passwd and'
echo '                     /etc/shadow'
echo '==================================================='
chown root /etc/passwd
chown root /etc/shadow
