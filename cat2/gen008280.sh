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
# on 20-Feb-2012 to point to the correct config entry.


#######################DISA INFORMATION###############################
#Group ID (Vulid): V-22570
#Group Title: GEN008280
#Rule ID: SV-26957r1_rule
#Severity: CAT II
#Rule Version (STIG-ID): GEN008280
#Rule Title: If the system is using LDAP for authentication or account information, the LDAP TLS certificate file must not have an extended ACL.
#
#Vulnerability Discussion: LDAP can be used to provide user authentication and account information, which are vital to system security. The LDAP client configuration must be protected from unauthorized modification.
#
#Responsibility: System Administrator
#IAControls: ECLP-1
#
#Check Content: 
#Determine the certificate file.
# grep -i '^tls_cacert' /etc/ldap.conf
#Check the permissions.
# ls -lL <certpath>
#If the permissions of the file contains a '+', an extended ACL is present. This is a finding.
#
#Fix Text: Remove the extended ACL from the certificate file.    
#######################DISA INFORMATION###############################

#Global Variables#
PDI=GEN008280

#Start-Lockdown
if [ -e /etc/ldap.conf ]; then
	echo '==================================================='
	echo ' Patching GEN008280: Remove ACLs from LDAP TLS'
	echo '                     Certificate'
	echo '==================================================='
	TLSCERTS=$(  grep -i '^tls_cert' /etc/ldap.conf | awk '{print $2}' )
	for line in $TLSCERTS; do
		if [ -a "$TLSCERTS" ]; then
			ACLOUT=`getfacl --skip-base $TLSCERTS 2>/dev/null`;
			if [ "$ACLOUT" != "" ]; then
				setfacl --remove-all $TLSCERTS
			fi
		fi
	done
fi
