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
#   - Updated by Shannon Mitchell(shannon.mitchell@fusiontechnology-llc.com)
#  on 02-feb-2011 to run check before running chmod and to allow for 
# "less permissive" permissions.


#######################DISA INFORMATION###############################
#Group ID (Vulid): V-22406
#Group Title: GEN003522
#Rule ID: SV-26612r1_rule
#Severity: CAT III
#Rule Version (STIG-ID): GEN003522
#Rule Title: The kernel core dump data directory must have mode 0700 or less permissive.
#
#Vulnerability Discussion: Kernel core dumps may contain the full contents of system memory at the time of the crash. As the system memory may contain sensitive information, it must be protected accordingly. If the mode of the kernel core dump data directory is more permissive than 0700, unauthorized users may be able to view or to modify kernel core dump data files.
#
#Responsibility: System Administrator
#IAControls: ECLP-1
#
#Check Content: 
#Determine the kernel core dump data directory and check its permissions.
# ls -l /var/crash
#If the directory has a mode more permissive than 0700, this is a finding.
#
#Check Content: 
#Determine the kernel core dump data directory and check its permissions.
#Examine /etc/kdump.conf. The "path" parameter, which defaults to /var/crash, determines the path relative to the crash dump device. The crash device is specified with a filesystem type and device, such as "ext3 /dev/sda2". Using this information, determine where this path is currently mounted on the system.
# ls -l <kernel dump directory>
#If the directory has a mode more permissive than 0700, this is a finding.
#
#Fix Text: Change the group-owner of the kernel core dump data directory.
# chmod 0700 /var/crash
#
#Fix Text: Change the group-owner of the kernel core dump data directory.
# chmod 0700 <kernel core dump data directory>   
#######################DISA INFORMATION###############################

#Global Variables#
PDI=GEN003522
CRASHDIR=$( cat /etc/kdump.conf | egrep '(path|#path)' | grep "/" | awk '{print $2}' )

#Start-Lockdown
if [ -a "$CRASHDIR" ]; then
	echo '==================================================='
	echo ' Patching GEN003522: Crash Directory Permissions'
	echo '==================================================='
	# Pull the actual permissions
	FILEPERMS=`stat -L --format='%04a' $CRASHDIR`

	# Break the actual file octal permissions up per entity
	FILESPECIAL=${FILEPERMS:0:1}
	FILEOWNER=${FILEPERMS:1:1}
	FILEGROUP=${FILEPERMS:2:1}
	FILEOTHER=${FILEPERMS:3:1}

	# Run check by 'and'ing the unwanted mask(7077)
	if [ $(($FILESPECIAL&7)) != "0" ] || [ $(($FILEOWNER&0)) != "0" ] || [ $(($FILEGROUP&7)) != "0" ] || [ $(($FILEOTHER&7)) != "0" ]; then
		chmod u-s,g-rwxs,o-rwxt $CRASHDIR
	fi
fi

