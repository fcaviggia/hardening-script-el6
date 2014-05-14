#!/bin/bash

## (LNX00640: CAT II) The SA will ensure the owner of the /etc/securetty file 
## is root.
echo '==================================================='
echo ' Patching LNX00640: Set securetty owner'
echo '==================================================='
chown root /etc/securetty
