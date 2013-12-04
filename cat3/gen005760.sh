#!/bin/bash

## (GEN005760: CAT III) (Previously – G179) The SA will ensure the export 
## configuration file has permissions of 644, or more restrictive.
echo '==================================================='
echo ' Patching GEN005760: Set permissions of the export'
echo '                     config file'
echo '==================================================='
chmod 644 /etc/exports
