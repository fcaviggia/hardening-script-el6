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
#  - updated by Shannon Mitchell(shannon.mitchell@fusiontechanology-llc.com)
# on 24-jan-2012 to add a check for ACLs before removing them.


#######################DISA INFORMATION###############################
#Group ID (Vulid): V-22373
#Group Title: GEN002718
#Rule ID: SV-26513r1_rule
#Severity: CAT III
#Rule Version (STIG-ID): GEN002718
#Rule Title: System audit tool executables must not have extended ACLs.
#
#Vulnerability Discussion: To prevent unauthorized access or manipulation of system audit logs, the tools for manipulating those logs must be protected.
#
#Responsibility: System Administrator
#IAControls: ECLP-1
#
#Check Content: 
#Check the permissions of audit tool executables.
# ls -l /sbin/auditctl /sbin/auditd /sbin/ausearch /sbin/aureport /sbin/autrace /sbin/audispd
#If the permissions include a '+', the file has an extended ACL, this is a finding.
#
#Fix Text: Remove the extended ACL from the file.
# setfacl --remove-all <audit file>    
#######################DISA INFORMATION###############################

echo '==================================================='
echo ' Patching GEN002718: Remove ACLs from System Audit'
echo '                     Tools'
echo '==================================================='


#Global Variables#
PDI=GEN002718

#Start-Lockdown
for AUDITFILE in /sbin/auditctl /sbin/auditd /sbin/ausearch /sbin/aureport /sbin/autrace /sbin/audispd; do
	ACLOUT=`getfacl --skip-base $AUDITFILE 2>/dev/null`;
	if [ "$ACLOUT" != "" ]; then
		setfacl --remove-all $AUDITFILE
	fi
done
