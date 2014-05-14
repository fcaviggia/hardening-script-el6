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
#Group ID (Vulid): V-22350
#Group Title: GEN001490
#Rule ID: SV-26449r1_rule
#Severity: CAT III
#Rule Version (STIG-ID): GEN001490
#Rule Title: User home directories must not have extended ACLs.
#
#Vulnerability Discussion: Excessive permissions on home directories allow unauthorized access to user files.
#
#Responsibility: System Administrator
#IAControls: ECLP-1
#
#Check Content: 
#Check that user home directories have no extended ACLs.
# cut -d : -f 6 /etc/passwd | xargs -n1 ls -ld
#If the permissions include a '+', the file has an extended ACL this is a finding.
#
#Fix Text: Remove the extended ACL from the file.
# setfacl --remove-all [user home directory with extended ACL]   _
#######################DISA INFORMATION###############################

echo '==================================================='
echo ' Patch GEN001490: Remove ACLs from Home Directories'
echo '==================================================='

#Global Variables#
PDI=GEN001490
ACLHOMEDIR=$(cut -d : -f 6 /etc/passwd | xargs -n1 ls -ld |grep '+' | awk '{print $9}')
#Start-Lockdown
for DIR in $ACLHOMEDIR; do
	if [ -d $DIR ]; then
    		setfacl --remove-all $DIR
	fi
done
