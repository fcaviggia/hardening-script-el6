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
# on 02-feb-2012 to check group ownership before running chgrp.


#######################DISA INFORMATION###############################
#Group ID (Vulid): V-22405
#Group Title: GEN003521
#Rule ID: SV-26608r1_rule
#Severity: CAT III
#Rule Version (STIG-ID): GEN003521
#Rule Title: The kernel core dump data directory must be group-owned by root, bin, sys, or system.
#
#Vulnerability Discussion: Kernel core dumps may contain the full contents of system memory at the time of the crash. As the system memory may contain sensitive information, it must be protected accordingly. If the kernel core dump data directory is not group-owned by a system group, the core dumps contained in the directory may be subject to unauthorized access.
#
#Responsibility: System Administrator
#IAControls: ECLP-1
#
#Check Content: 
#Determine the kernel core dump data directory and check its ownership.
# ls -l /var/crash
#If the directory is not group-owned by root, this is a finding.
#
#Check Content: 
#Determine the kernel core dump data directory and check its ownership.
#Examine /etc/kdump.conf. The "path" parameter, which defaults to /var/crash, determines the path relative to the crash dump device. The crash device is specified with a filesystem type and device, such as "ext3 /dev/sda2". Using this information, determine where this path is currently mounted on the system.
# ls -l <kernel dump directory>
#If the directory is not group-owned by root, this is a finding.
#
#Fix Text: Change the group-owner of the kernel core dump data directory.
# chgrp root /var/crash
#Fix Text: Change the group-owner of the kernel core dump data directory.
# chgrp root <kernel core dump data directory>   
#######################DISA INFORMATION###############################

#Global Variables#
PDI=GEN003521
CRASHDIR=$( cat /etc/kdump.conf | egrep '(path|#path)' | grep "/" | awk '{print $2}' )

#Start-Lockdown
if [ -e "$CRASHDIR" ]; then
	echo '==================================================='
	echo ' Patching GEN003521: Core Dump Group Ownership'
	echo '==================================================='
	CURGOWN=`stat -c %G $CRASHDIR`;
	if [ "$CURGOWN" != "root" ]; then
		chgrp root $CRASHDIR
	fi
fi
