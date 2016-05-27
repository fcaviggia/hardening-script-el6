#!/bin/bash
#
#V-38603
#
#Rule Title: The ypserv package must not be installed.
#
# Removing the "ypserv" package decreases the risk of the 
# accidental (or intentional) activation of NIS or NIS+ services.
#
#Check Content: 
# Run the following command to determine if the "ypserv" package is installed: 
#  rpm -q ypserv 
# If the package is installed, this is a finding.
#  
#Fix Text: 
# The "ypserv" package can be uninstalled with the following command: 
# yum erase ypserv
#
echo '==================================================='
echo ' Patching V-38603: Remove ypserv Package'
echo '==================================================='

#Start-Lockdown
rpm -q ypserv > /dev/null
if [ $? -eq 0 ]; then
	rpm -e --nodeps ypserv
fi
