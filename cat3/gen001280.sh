#!/bin/sh

## (GEN001280: CAT III) (Previously – G042) The SA will ensure all manual page
## files (i.e.,files in the man and cat directories) have permissions of 644,
## or more restrictive.
echo '==================================================='
echo ' Patching GEN001280: Set manual page permissions'
echo '==================================================='
find /usr/share/man -type f -exec chmod 644 {} \;
