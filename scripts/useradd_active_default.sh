#!/bin/bash
#
#V-38692
#V-38694
#
#Rule Title: Accounts must be locked upon 35 days of inactivity.
# 
#Discussion:
# Disabling inactive accounts ensures that accounts which may not have been 
# responsibly removed are not available to attackers who may have compromised 
# their credentials.
#
#Check Content: 
# To verify the "INACTIVE" setting, run the following command: 
#    grep "INACTIVE" /etc/default/useradd 
# The output should indicate the "INACTIVE" configuration option is set to an 
# appropriate integer as shown in the example below: 
#    grep "INACTIVE" /etc/default/useradd 
#    INACTIVE=35  
#
#Fix Text: 
# To specify the number of days after a password expires (which signifies 
# inactivity) until an account is permanently disabled, add or correct the 
# following lines in "/etc/default/useradd", substituting "[NUM_DAYS]" 
# appropriately: 
#  INACTIVE=[NUM_DAYS] 
#
echo '==================================================='
echo ' Patching V-38692: Lock accounts upon 35 days of inactivity.'
echo '==================================================='

grep INACTIVE=-1 /etc/default/useradd > /dev/null
if [ $? -eq 0 ]; then
	sed -i -e 's/INACTIVE=-1/INACTIVE=35/g' /etc/default/useradd
fi

