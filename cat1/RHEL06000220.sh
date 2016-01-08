#!/bin/bash
######################################################################
#By Luke "Brisk-OH" Brisk		                     #
#(Luke.Brisk@Boeing.com or Luke.Brisk@gmail.com)				     #
######################################################################
#_____________________________________________________________________
#|  Version |   Change Information  |      Author        |    Date    |
#|__________|_______________________|____________________|____________|
#|    1.0   |   Initial Script      | Luke Brisk		 | 27-oct-2014|
#|	   		|   Creation	    	|                    |            |
#|__________|_______________________|____________________|____________|
#
# Group ID (Vulid):  V-38603
# Group Title:  SRG-OS-000095
# Rule ID:  SV-50404r1_rule
# Severity: CAT II
# Rule Version (STIG-ID):  RHEL-06-000220
# Rule Title: The ypserv package must not be installed.
#
#
# Vulnerability Discussion:  Removing the "ypserv" package decreases the risk of the accidental (or intentional) activation of NIS or NIS+ services.
#
# Check Content:  
# Run the following command to determine if the "ypserv" package is installed: 
#
#rpm -q ypserv
#
# If the package is installed, this is a finding.
#
# Fix Text: The "ypserv" package can be uninstalled with the following command: 
#
#yum erase ypserv   
#
# CCI: CCI-000381


#Global Variables#
PDI=GEN006380

#Start-Lockdown

# There is no built in way to do this, so lets go with redhat's recommendations
# for securing NIS and set a static port.  udp can be blocked with iptables.

rpm -q ypserv > /dev/null
if [ $? -eq 0 ]; then
echo '===================================================================='
echo ' Patching RHEL-06-000220: The ypserv package must not be installed. '
echo '===================================================================='
yum erase ypserv 
  
fi
