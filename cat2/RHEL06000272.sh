#!/bin/bash
######################################################################
#By Luke "Brisk-OH" Brisk		                    				 #
#luke.brisk@boeing.com or luke.brisk@gmail.com					     #
######################################################################
#_____________________________________________________________________
#|  Version |   Change Information  |      Author        |    Date    |
#|__________|_______________________|____________________|____________|
#|    1.0   |   Initial Script      | Luke Brisk		 | 27-oct-2014|
#|	    	|   Creation	    	|                    |            |
#|__________|_______________________|____________________|____________|
#
# Group ID (Vulid):  V-38656
# Group Title:  SRG-OS-999999
# Rule ID:  SV-50457r1_rule
# Severity: CAT III
# Rule Version (STIG-ID):  RHEL-06-000272
# Rule Title: The system must use SMB client signing for connecting to samba servers using smbclient.
#
# Vulnerability Discussion:  Packet signing can prevent man-in-the-middle attacks which modify SMB packets in transit.
#
# Check Content:  
# To verify that Samba clients running smbclient must use packet signing, run the following command: 
#
#grep signing /etc/samba/smb.conf
#
# The output should show: 
#
# client signing = mandatory
#
# If it is not, this is a finding.
#
# Fix Text: To require samba clients running "smbclient" to use packet signing, add the following to the "[global]" section of the Samba configuration file in "/etc/samba/smb.conf": 
#
# client signing = mandatory
#
# Requiring samba clients such as "smbclient" to use packet signing ensures they can only communicate with servers that support packet signing.   
#
# CCI: CCI-000366
#
#Global Variables
PDI=RHEL-06-000272

#Start-Lockdown
if [ -e /etc/samba/smb.conf ]; then
	echo '==========================================================='
	echo ' RHEL-06-000272: The system must use SMB client signing	 '
	echo ' for connecting to samba servers using smbclient.			 '
	echo '==========================================================='

	$CLIENTSIGNINGS=$( grep -i 'client signing' /etc/samba/smb.conf | wc -l )

	if [ $CLIENTSIGNING -eq 0 ];  then
		# Add to global section
		sed -i 's/\[global\]/\[global\]\n\n\tclient signing = mandatory/g' /etc/samba/smb.conf
	else
		sed -i 's/[[:blank:]]*client[[:blank:]]signing[[:blank:]]*=[[:blank:]]*no/        client signing = mandatory/g' /etc/samba/smb.conf
	fi
fi
