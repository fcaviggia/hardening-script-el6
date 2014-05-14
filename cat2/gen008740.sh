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
# on 20-Feb-2012 to include an ACL check before running setfacl.


#######################DISA INFORMATION###############################
#Group ID (Vulid): V-22585
#Group Title: GEN008740
#Rule ID: SV-26984r1_rule
#Severity: CAT II
#Rule Version (STIG-ID): GEN008740
#Rule Title: The system's boot loader configuration file(s) must not have extended ACLs.
#
#Vulnerability Discussion: File system extended ACLs provide access to files beyond what is allowed by the mode numbers of the files. If extended ACLs are present on the system's boot loader configuration file(s), these files may be vulnerable to unauthorized access or modification, which could compromise the system's boot process.
#
#Responsibility: System Administrator
#IAControls: ECLP-1
#
#Check Content: 
#Check the permissions of the file.
# ls -lLd /boot/grub/grub.conf
#If the permissions of the file or directory contains a '+', an extended ACL is present. This is a finding.
#
#Fix Text: Remove the extended ACL from the file.
# setfacl --remove-all /boot/grub/grub.conf    
#######################DISA INFORMATION###############################

#Global Variables#
PDI=GEN008740

#Start-Lockdown

if [ -a "/boot/grub/grub.conf" ]; then
	echo '==================================================='
	echo ' Patching GEN008740: Remove ACLs from grub.conf '
	echo '==================================================='
	ACLOUT=`getfacl --skip-base /boot/grub/grub.conf 2>/dev/null`;
	if [ "$ACLOUT" != "" ]; then
		setfacl --remove-all /boot/grub/grub.conf
	fi
fi
