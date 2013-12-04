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
#Group ID (Vulid): V-22370
#Group Title: GEN002715
#Rule ID: SV-26504r1_rule
#Severity: CAT III
#Rule Version (STIG-ID): GEN002715
#Rule Title: System audit tool executables must be owned by root.
#
#Vulnerability Discussion: To prevent unauthorized access or manipulation of system audit logs, the tools for manipulating those logs must be protected.
#
#Responsibility: System Administrator
#IAControls: ECLP-1
#
#Check Content: 
#Check that the audit tool executables are owned by root.
# ls -l /sbin/auditctl /sbin/auditd /sbin/ausearch /sbin/aureport /sbin/autrace /sbin/audispd
#If any listed file is not owned by root, this is a finding.
#
#Fix Text: Change the owner of the audit tool executable to root.
# chown root <audit tool executable>   
#######################DISA INFORMATION###############################

echo '==================================================='
echo ' Patching GEN002715: System Audit Tool Ownership'
echo '==================================================='

#Global Variables#
PDI=GEN002715

AUDITTOOLS=$( find /sbin/auditctl /sbin/auditd /sbin/ausearch /sbin/aureport /sbin/autrace /sbin/audispd ! -user root )

#Start-Lockdown
for FILE in $AUDITTOOLS; do 
	if [ -e $FILE ]; then
		chown root $FILE
	fi
done

