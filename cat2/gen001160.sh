#!/bin/sh

## (GEN001160: CAT II) All files and direcotries must have a 
## vaild owner and group.
echo '==================================================='
echo ' Patching GEN001160: File and Directory Ownership'
echo '==================================================='

NOUSERS=`find / -nouser 2>/dev/null | wc -l 2>/dev/null`

if [ $NOUSERS -ge 1 ];  then
    echo "------------------------------" 
    date 
    echo " " 
    echo "The following files don't have proper USER ownership." 
    echo "Please review and fix as needed" 
    echo " " 
    find / -nouser 2>/dev/null 
    echo "------------------------------" 
fi
