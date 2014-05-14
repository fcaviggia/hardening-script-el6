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
#Group ID (Vulid): V-4688
#Group Title: The rexec service is enabled
#Rule ID: SV-27439r1_rule
#Severity: CAT I
#Rule Version (STIG-ID): GEN003840
#Rule Title: The rexec daemon must not be running.
#
#Vulnerability Discussion: The rexecd process provides a typically unencrypted, host-authenticated remote access service. SSH should be used in place of this service.
#
#
#Responsibility: System Administrator
#IAControls: ECSC-1
#
#Check Content: 
# grep disable /etc/xinetd.d/rexec
#If the service file exists and is not disabled, this is a finding.
#
#Fix Text: Edit /etc/xinetd.d/rexec and set "disable=yes".   
#######################DISA INFORMATION###############################

#Global Variables#
PDI=GEN003840

#Start-Lockdown
#Check if rsh installed
if [ -e /etc/xinetd.d/rexec ]; then
echo '==================================================='
echo ' Patching GEN003840: Disable rexec Daemon'
echo '==================================================='
    sed -i 's/[[:blank:]]*disable[[:blank:]]*=[[:blank:]]*no/        disable                 = yes/g' /etc/xinetd.d/rexec
fi
