#!/bin/bash
#
#V-38606
#
#Rule Title: The tftp-server package must not be installed unless required.
#
# Removing the "tftp-server" package decreases the risk of the accidental (or
# intentional) activation of tftp services.
#
#Check Content: 
# Run the following command to determine if the "tftp-server" package is installed: 
#  rpm -q tftp-server  
#
#Fix Text: 
# The "tftp-server" package can be removed with the following command: 
#  yum erase tftp-server

echo '==================================================='
echo ' Patching V-38606: Remove tftp-server Package'
echo '==================================================='


#Start-Lockdown
rpm -q tftp-server > /dev/null
if [ $? -eq 0 ]; then
	rpm -e --nodeps tftp-server
fi
