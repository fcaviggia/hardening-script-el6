#!/bin/bash

## (GEN004380: CAT II) (Previously – G128) The SA will ensure the aliases file 
## has permissions of 644, or more restrictive.
echo '==================================================='
echo ' Patching GEN004380: Set permissions of aliases file'
echo '==================================================='
chmod 644 /etc/aliases
