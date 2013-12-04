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
#Group ID (Vulid): V-22577
#Group Title: GEN008440
#Rule ID: SV-26963r1_rule
#Severity: CAT III
#Rule Version (STIG-ID): GEN008440
#Rule Title: Automated file system mounting tools must not be enabled unless needed.
#
#Vulnerability Discussion: Automated file system mounting tools may provide unprivileged users with the ability to access local media and network shares. If this access is not necessary for the system’s operation, it must be disabled to reduce the risk of unauthorized access to these resources.
#
#Responsibility: System Administrator
#IAControls: ECSC-1
#
#Check Content: 
#If the autofs service is needed, this vulnerability is not applicable.
#Check if the autofs service is running.
# service autofs status
#If the service is running, this is a finding.
#
#Fix Text: Stop and disable the autofs service.
# service autofs stop
# chkconfig autofs off
#######################DISA INFORMATION###############################

#Global Variables#
PDI=GEN008440

#Start-Lockdown
AUTOSERVICE=$( service autofs status 2>/dev/null | grep "running..." | wc -l )
if [ $AUTOSERVICE -ne 0 ]; then
	echo '==================================================='
	echo ' Patching GEN008440: Disable autofs Service'
	echo '==================================================='
	service autofs stop &>/dev/null
	chkconfig autofs off &>/dev/null
fi


