#!/bin/bash

## (GEN003780: CAT II) (Previously – G110) The SA will ensure the services 
## file has permissions of 644, or more restrictive.
echo '==================================================='
echo ' Patching GEN003780: Set permissions of the services'
echo '                     file'
echo '==================================================='
chmod 644 /etc/services
