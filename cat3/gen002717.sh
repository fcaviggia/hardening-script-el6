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
#  - updated by Shannon Mitchell(shannon.mitchell@fusiontechnology-llc.com)
# on 24-jan-2012 to check the permissions before running the chmod.


#######################DISA INFORMATION###############################
#Group ID (Vulid): V-22372
#Group Title: GEN002717
#Rule ID: SV-26510r1_rule
#Severity: CAT III
#Rule Version (STIG-ID): GEN002717
#Rule Title: System audit tool executables must have mode 0750 or less permissive.
#
#Vulnerability Discussion: To prevent unauthorized access or manipulation of system audit logs, the tools for manipulating those logs must be protected.
#
#Responsibility: System Administrator
#IAControls: ECLP-1
#
#Check Content: 
#Check the mode of audit tool executables.
# ls -l /sbin/auditctl /sbin/auditd /sbin/ausearch /sbin/aureport /sbin/autrace /sbin/audispd
#If any listed file has a mode more permissive than 0750, this is a finding.
#
#Fix Text: Change the mode of the audit tool executable to 0750, or less permissive.
# chmod 0750 <audit tool executable>    
#######################DISA INFORMATION###############################

echo '==================================================='
echo ' Patching GEN002717: System Audit Tool Permissions'
echo '==================================================='

#Global Variables#
PDI=GEN002717

#Start-Lockdown
find /sbin/auditctl /sbin/auditd /sbin/ausearch /sbin/aureport /sbin/autrace /sbin/audispd -perm /7027 -exec chmod u-s,g-ws,o-rwxt {} \;
