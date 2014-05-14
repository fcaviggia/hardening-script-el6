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
# on 31-jan-2012 to include an ACL check before running setfacl.
								     

#######################DISA INFORMATION###############################
#Group ID (Vulid): V-22389
#Group Title: GEN003210
#Rule ID: SV-26544r1_rule
#Severity: CAT II
#Rule Version (STIG-ID): GEN003210
#Rule Title: The cron.deny file must not have an extended ACL.
#
#Vulnerability Discussion: If the cron.deny file must be protected from unauthorized access or manipulation.
#
#Responsibility: System Administrator
#IAControls: ECLP-1
#
#Check Content: 
#Check the permissions of the file.
# ls -lL /etc/cron.deny
#If the permissions include a '+', the file has an extended ACL, this is a finding.
#
#Fix Text: Remove the extended ACL from the file.
# setfacl --remove-all /etc/cron.deny    
#######################DISA INFORMATION###############################

#Global Variables#
PDI=GEN003210

#Start-Lockdown
if [ -a "/etc/cron.deny" ]; then
	echo '==================================================='
	echo ' Patching GEN003210: Remove ACLs from /etc/cron.deny'
	echo '==================================================='
	ACLOUT=`getfacl --skip-base /etc/cron.deny 2>/dev/null`;
	if [ "$ACLOUT" != "" ]; then
		setfacl --remove-all /etc/cron.deny
	fi
fi
