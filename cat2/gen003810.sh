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
# on 04-Feb-2012 to check service status before disabling it.


#######################DISA INFORMATION###############################
#Group ID (Vulid): V-22429
#Group Title: GEN003810
#Rule ID: SV-26662r1_rule
#Severity: CAT II
#Rule Version (STIG-ID): GEN003810
#Rule Title: The portmap or rpcbind service must not be running unless needed.
#
#Vulnerability Discussion: The portmap and rpcbind services increase the attack surface of the system and should only be used when needed. The portmap or rpcbind services are used by a variety of services using remote procedure calls (RPCs).
#
#Responsibility: System Administrator
#IAControls: ECSC-1
#
#Check Content: 
#Check the status of the portmap service.
# service portmap status
#If the service is running, this is a finding.
#
#Fix Text: Shutdown and disable the portmap service.
# service portmap stop; chkconfig portmap off   
#######################DISA INFORMATION###############################

#Global Variables#
PDI=GEN003810

#Start-Lockdown
chkconfig --list | grep portmap | grep ':on' > /dev/null
if [ $? -eq 0 ]; then
	echo '==================================================='
	echo ' Patching GEN003810: Disable portmap Service'
	echo '==================================================='

	service portmap stop &>/dev/null
	chkconfig portmap off
fi
