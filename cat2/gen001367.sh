#!/bin/bash
######################################################################
#By Tummy a.k.a Vincent C. Passaro				     #
#Vincent[.]Passaro[@]gmail[.]com	         		     #
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
#  - Updated by Shannon Mitchell (shannon.mitchell@fusiontechnology-llc.com)
# on 30-dec-2011 to include a group ownership check before running.
								     

#######################DISA INFORMATION###############################
#Group ID (Vulid): V-22324
#Group Title: GEN001367
#Rule ID: SV-26411r1_rule
#Severity: CAT II
#Rule Version (STIG-ID): GEN001367
#Rule Title: The /etc/hosts file must be group-owned by root, bin, sys, or system.
#
#Vulnerability Discussion: The /etc/hosts file (or equivalent) configures local host name to IP address mappings that typically take precedence over DNS resolution. If this file is maliciously modified, it could cause the failure or compromise of security functions requiring name resolution, which may include time synchronization, centralized authentication, and remote system logging.
#
#Responsibility: System Administrator
#IAControls: ECLP-1
#
#Check Content: 
#Check the /etc/hosts file's group ownership.
#
#Procedure:
# ls -lL /etc/hosts
#
#If the file is not group-owned by root, bin, sys, or system, this is a finding.
#
#Fix Text: Change the group-owner of the /etc/hosts file to root, sys, bin, or system.
#
#Procedure:
# chgrp root /etc/hosts    
#######################DISA INFORMATION###############################

#Global Variables#
PDI=GEN001367

#Start-Lockdown
if [ -a "/etc/hosts" ]; then
	echo '==================================================='
	echo ' Patching GEN001367: /etc/hosts Group Ownership'
	echo '==================================================='
	CURGOWN=`stat -c %G /etc/hosts`;
	if [ "$CURGOWN" != "root" -a "$CURGOWN" != "sys" -a "$CURGOWN" != "bin" -a "$CURGOWN" != "system" ]; then
		chgrp root /etc/hosts
    	fi
fi
