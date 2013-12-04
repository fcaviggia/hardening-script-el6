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
# on 02-feb-2012 to include an ACL check before running setfacl.
								     

#######################DISA INFORMATION###############################
#Group ID (Vulid): V-22407
#Group Title: GEN003523
#Rule ID: SV-26616r1_rule
#Severity: CAT III
#Rule Version (STIG-ID): GEN003523
#Rule Title: The kernel core dump data directory must not have an extended ACL.
#
#Vulnerability Discussion: Kernel core dumps may contain the full contents of system memory at the time of the crash. As the system memory may contain sensitive information, it must be protected accordingly. If there is an extended ACL for the kernel core dump data directory, unauthorized users may be able to view or to modify kernel core dump data files.
#
#Responsibility: System Administrator
#IAControls: ECLP-1
#
#Check Content: 
#Determine the kernel core dump data directory and check its permissions.
# ls -l /var/crash
#If the permissions include a '+', the file has an extended ACL, this is a finding.
#
#Check Content: 
#Determine the kernel core dump data directory and check its permissions.
#Examine /etc/kdump.conf. The "path" parameter, which defaults to /var/crash, determines the path relative to the crash dump device. The crash device is specified with a filesystem type and device, such as "ext3 /dev/sda2". Using this information, determine where this path is currently mounted on the system.
# ls -l <kernel dump directory>
#If the permissions include a '+', the file has an extended ACL, this is a finding.
#
#Fix Text: Remove the extended ACL from the file.
# setfacl --remove-all /var/crash
#Fix Text: Remove the extended ACL from the file.
# setfacl --remove-all <core file directory>   
#######################DISA INFORMATION###############################

#Global Variables#
PDI=GEN003523
CRASHDIR=$( cat /etc/kdump.conf | egrep '(path|#path)' | grep "/" | awk '{print $2}' )

#Start-Lockdown
if [ -a "$CRASHDIR" ]; then
	echo '==================================================='
	echo ' Patching GEN003523: Remove ACLs from Core Files'
	echo '==================================================='
	ACLOUT=`getfacl --skip-base $CRASHDIR 2>/dev/null`;
	if [ "$ACLOUT" != "" ]; then
		setfacl --remove-all $CRASHDIR
	fi
fi
