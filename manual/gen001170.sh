#!/bin/sh

echo '===================================================' | tee -a $PDI-NOGROUP.log
echo ' Manual Check GEN003865: Files and Directories'      | tee -a $PDI-NOGROUP.log
echo '                         Without Group Ownership.'   | tee -a $PDI-NOGROUP.log
echo '===================================================' | tee -a $PDI-NOGROUP.log

PDI=GEN001170
NOGROUPS=`find / -nogroup 2>/dev/null | wc -l `

if [ $NOGROUPS -ge 1 ]; then
    echo "------------------------" >> $PDI-NOGROUP.log
    date >> $PDI-NOGROUP.log
    echo " " >> $PDI-NOGROUP.log
    echo "The following files don't have proper GROUP ownership." >> $PDI-NOGROUP.log
    echo "Please review and fix as needed" >> $PDI-NOGROUP.log
    echo " " >> $PDI-NOGROUP.log
    find / -nogroup 2>/dev/null >> $PDI-NOGROUP.log
    echo "------------------------------" >> $PDI-NOGROUP.log
fi
less $PDI-NOGROUP.log
