#!/bin/bash
######################################################################
#By Luke "Brisk-OH" Brisk-OH					                     #
#luke.brisk@boeing.com or luke.brisk@gmail.com					     #
######################################################################
#_____________________________________________________________________
#|  Version |   Change Information  |      Author        |    Date    |
#|__________|_______________________|____________________|____________|
#|    1.0   |   Initial Script      | Luke Brisk-OH		 | 27-oct-2014|
#|	    	|   Creation	    	|                    |            |
#|__________|_______________________|____________________|____________|
#



#######################DISA INFORMATION###############################
# Group ID (Vulid):  V-38606
# Group Title:  SRG-OS-000095
# Rule ID:  SV-50407r1_rule
# Severity: CAT II
# Rule Version (STIG-ID):  RHEL-06-000222
# Rule Title: The tftp-server package must not be installed.
#
# Vulnerability Discussion:  Removing the "tftp-server" package decreases the risk of the accidental (or intentional) activation of tftp services.
#
# Check Content:  
# Run the following command to determine if the "tftp-server" package is installed: 
#
# rpm -q tftp-server
#
# If the package is installed, this is a finding.
#
# Fix Text: The "tftp-server" package can be removed with the following command: 
#
# yum erase tftp-server   
#
# CCI: CCI-000381

#######################DISA INFORMATION###############################

#Global Variables#
PDI=RHEL-06-000222

#Start-Lockdown

rpm -q tftp-server > /dev/null
if [ $? -eq 0 ]; then
echo '==============================================================='
echo ' RHEL-06-000222: The tftp-server package must not be installed.'
echo '==============================================================='
	yum erase tftp-server   
fi
