#!/bin/bash
#
#V-38584
#
#Rule Title: The xinetd service must be uninstalled if no network services 
#            utilizing it are enabled.
#
# Removing the "xinetd" package decreases the risk of the xinetd service's 
# accidental (or intentional) activation.
#
#Check Content: 
# If network services are using the xinetd service, this is not applicable. 
#
# Run the following command to determine if the "xinetd" package is installed: 
#  rpm -q xinetd 
#
#Fix Text: 
# The "xinetd" package can be uninstalled with the following command: 
#  yum erase xinetd

echo '==================================================='
echo ' Patching V-38584: Remove xinetd Package'
echo '==================================================='


#Start-Lockdown
rpm -q xinetd > /dev/null
if [ $? -eq 0 ]; then
	rpm -e --nodeps xinetd
fi
