#!/bin/sh

## (LNX00160: CAT II) (Previously – L074) The SA will ensure the grub.conf file has
## permissions of 600, or more restrictive.
echo '==================================================='
echo ' Patching LNX00160: GRUB Permissions'
echo '==================================================='
chmod 600 /boot/grub/grub.conf
chown root:root /boot/grub/grub.conf
