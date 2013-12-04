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
# on 20-Feb-2012 to check service status before disabling it.


#######################DISA INFORMATION###############################
#Group ID (Vulid): V-22589
#Group Title: GEN008820
#Rule ID: SV-26992r1_rule
#Severity: CAT III
#Rule Version (STIG-ID): GEN008820
#Rule Title: The system package management tool must not automatically obtain updates.#
#
#Vulnerability Discussion: System package management tools can obtain a list of updates and patches from a package repository and make this information available to the SA for review and action. Using a package repository outside of the organization's control presents a risk that malicious packages could be introduced.
#
#Responsibility: System Administrator
#IAControls: ECSC-1
#
#Check Content: 
#Check that the yum service is enabled.
# service yum-updatesd status
#If the service is enabled, this is a finding.
#
#Fix Text: Disable the yum service.
# chkconfig yum-updatesd off ; service yum-updatesd stop   
#######################DISA INFORMATION###############################

#Global Variables#
PDI=GEN008820

#Start-Lockdown
chkconfig --list yum-updatesd 2>/dev/null | grep ':on' > /dev/null
if [ $? -eq 0 ]; then
	echo '==================================================='
	echo ' Patching GEN008820: Disable yum Services '
	echo '==================================================='
	service yum-updatesd stop &> /dev/null
	chkconfig yum-updatesd off &> /dev/null
fi
