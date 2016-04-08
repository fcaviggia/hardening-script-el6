#!/bin/bash
#
#V-38587
#
#Rule Title: The telnet-server package must not be installed.
#
# Removing the "telnet-server" package decreases the risk of the unencrypted telnet
# service's accidental (or intentional) activation. 
#
#Check Content: 
# Run the following command to determine if the "telnet-server" package is installed: 
#  rpm -q telnet-server 
#
#Fix Text: 
# The "telnet-server" package can be uninstalled with the following command: 
#
# yum erase telnet-server
#
echo '==================================================='
echo ' Patching V-38587: Remove telnet-server Package'
echo '==================================================='


#Start-Lockdown
rpm -q telnet-server > /dev/null
if [ $? -eq 0 ]; then
	rpm -e --nodeps telnet-server
fi
