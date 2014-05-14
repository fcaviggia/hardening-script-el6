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
#######################DISA INFORMATION###############################
#Group ID (Vulid): V-22562
#Group Title: GEN008120
#Rule ID: SV-26949r1_rule
#Severity: CAT II
#Rule Version (STIG-ID): GEN008120
#Rule Title: If the system is using LDAP for authentication or account information, the /etc/ldap.conf (or equivalent) file must not have an extended ACL.
#
#Vulnerability Discussion: LDAP can be used to provide user authentication and account information, which are vital to system security. The LDAP client configuration must be protected from unauthorized modification.
#
#Responsibility: System Administrator
#IAControls: ECLP-1
#
#Check Content: 
#Check the permissions of the file.
# ls -lL /etc/ldap.conf
#If the permissions include a '+', the file has an extended ACL, this is a finding.
#
#Fix Text: Remove the extended ACL from the /etc/ldap.conf file.   
#######################DISA INFORMATION###############################

#Global Variables#
PDI=GEN008120

#Start-Lockdown
if [ -a "/etc/ldap.conf" ]; then
	echo '==================================================='
	echo ' Patching GEN008120: Remove ACLs from ldap.conf'
	echo '==================================================='
	ACLOUT=`getfacl --skip-base /etc/ldap.conf 2>/dev/null`;
	if [ "$ACLOUT" != "" ]; then
		setfacl --remove-all /etc/ldap.conf
	fi
fi

