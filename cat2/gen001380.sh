#!/bin/bash

## (GEN001380: CAT II) (Previously – G048) The SA will ensure the /etc/passwd 
## file has permissions of 644, or more restrictive.
echo '==================================================='
echo ' Patching GEN001380: Set permissions of /etc/passwd'
echo '==================================================='
chmod 644 /etc/passwd
