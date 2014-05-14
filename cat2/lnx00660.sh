#!/bin/bash

## (LNX00660: CAT II) The SA will ensure the /etc/securetty file has 
## permissions of 640, or more restrictive.
echo '==================================================='
echo ' Patching LNX00660: Set securetty permissions'
echo '==================================================='
chmod 640 /etc/securetty
