#!/bin/bash

## (LNX00620: CAT II) The SA will ensure the group owner of the /etc/securetty 
## file is root, sys, or bin.
echo '==================================================='
echo ' Patching LNX00620: Set securetty group owner'
echo '==================================================='
chgrp root /etc/securetty
