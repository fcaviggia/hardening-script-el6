#!/bin/bash
######################################################################
#By Tummy a.k.a Vincent C. Passaro		                     #
#Vincent[.]Passaro[@]gmail[.]com				     #
#www.vincentpassaro.com						     #
######################################################################
#_____________________________________________________________________
#|  Version |   Change Information  |      Author        |    Date    |
#|__________|_______________________|____________________|____________|
#|    1.0   |   Initial Script      | Vincent C. Passaro | 20-oct-2011|
#|	    |   Creation	    |                    |            |
#|__________|_______________________|____________________|____________|
#
#
#  - Updated by Shannon Mitchell(shannon.mitchell@fusiontechnology-llc.com)
# on 05-Feb-2012 to include an ACL check before running setfacl.


#######################DISA INFORMATION###############################
#Group ID (Vulid): V-22454
#Group Title: GEN005395
#Rule ID: SV-26741r1_rule
#Severity: CAT II
#Rule Version (STIG-ID): GEN005395
#Rule Title: The /etc/syslog.conf file must not have an extended ACL.
#
#Vulnerability Discussion: Unauthorized users must not be allowed to access or modify the /etc/syslog.conf file.
#
#Responsibility: System Administrator
#IAControls: ECLP-1
#
#Check Content: 
#Check the permissions of the syslog configuration file.
# ls -lL /etc/syslog.conf
#If the permissions include a '+', the file has an extended ACL, this is a finding.
#
#Fix Text: Remove the extended ACL from the file.
# setfacl --remove-all /etc/syslog.conf   
#######################DISA INFORMATION###############################

#Global Variables#
PDI=GEN005395

#Start-Lockdown
if [ -a "/etc/syslog.conf" ]; then
	echo '==================================================='
	echo ' Patching GEN005395: Remove ACLs from syslog.conf'
	echo '==================================================='
	ACLOUT=`getfacl --skip-base /etc/syslog.conf 2>/dev/null`;
	if [ "$ACLOUT" != "" ]; then
		setfacl --remove-all /etc/syslog.conf
	fi
fi
