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
#  - updated by Shannon Mitchell(shannon.mitchell@fusiontechnology-llc.com) on
# 24-jan-2012 to check the group permissions before running chgrp.


#######################DISA INFORMATION###############################
#Group ID (Vulid): V-22371
#Group Title: GEN002716
#Rule ID: SV-26507r1_rule
#Severity: CAT III
#Rule Version (STIG-ID): GEN002716
#Rule Title: System audit tool executables must be group-owned by root, bin, sys, or system.
#
#Vulnerability Discussion: To prevent unauthorized access or manipulation of system audit logs, the tools for manipulating those logs must be protected.
#
#Responsibility: System Administrator
#IAControls: ECLP-1
#
#Check Content: 
#Check that the audit tool executables are group-owned by root, bin, sys, or system.
#
#Procedure:
# ls -lL /sbin/auditctl /sbin/auditd /sbin/ausearch /sbin/aureport /sbin/autrace /sbin/audispd
#
#If any listed file is not group-owned by root, bin, sys, or system, this is a finding.
#
#Fix Text: Change the group-owner of the audit tool executable to root, bin, sys, or system.
#
#Procedure:
# chgrp root <audit tool executable>    
#######################DISA INFORMATION###############################

echo '==================================================='
echo ' Patching GEN002716: System Audit Tool Group'
echo '                     Ownership'
echo '==================================================='

#Global Variables#
PDI=GEN002716

#Start-Lockdown
find /sbin/auditctl /sbin/auditd /sbin/ausearch /sbin/aureport /sbin/autrace /sbin/audispd ! -group root ! -group bin ! -group sys -exec chgrp root {} \;
