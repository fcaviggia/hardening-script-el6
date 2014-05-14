#!/bin/bash
#####################Fotis Networks LLC###############################
#By Tummy a.k.a Vincent C. Passaro				     #
#Fotis Networks LLC						     #
#Vincent[.]Passaro[@]fotisnetworks[.]com			     #
#www.fotisnetworks.com						     #
######################Fotis Networks LLC##############################

#_____________________________________________________________________
#|  Version |   Change Information  |      Author        |    Date    |
#|__________|_______________________|____________________|____________|
#|    1.0   |   Initial Script      | Vincent C. Passaro | 20-oct-2011|
#|	    |   Creation	    |                    |            |
#|__________|_______________________|____________________|____________|
#
#
#  - Updated by Shannon Mitchell(shannon.mitchell@fusiontechnology-llc.com)
# on 09-jan-2012.  Moved from manual to prod and created check.
								     

#######################DISA INFORMATION###############################
#Group ID (Vulid): V-789
#Group Title: NIS/NIS+/yp File Ownership
#Rule ID: SV-27170r1_rule
#Severity: CAT II
#Rule Version (STIG-ID): GEN001320
#Rule Title: NIS/NIS+/yp files must be owned by root, sys, or bin.
#
#Vulnerability Discussion: NIS/NIS+/yp files are part of the system's identification and authentication processes and are, therefore, critical to system security. Failure to give ownership of sensitive files or utilities to root or bin provides the designated owner and unauthorized users with the potential to access sensitive information or change the system configuration which could weaken the system's security posture.
#
#
#Responsibility: System Administrator
#IAControls: ECLP-1
#
#Check Content: 
#Perform the following to check NIS file ownership:
# ls -la /var/yp/*;
#If the file ownership is not root, sys, or bin, this is a finding.
#
#Fix Text: Change the ownership of NIS/NIS+/yp files to root, sys, bin, or system. Consult vendor documentation to determine the location of the files.
#
#Procedure (example):
# chown root <filename>   
#######################DISA INFORMATION###############################

#Global Variables#
PDI=GEN001320

#Start-Lockdown
if [ -d '/var/yp' ]; then
echo '==================================================='
echo ' Patching GEN001320: NIS User Ownership'
echo '==================================================='
echo '==================================================='
echo ' Patching GEN001340: NIS Group Ownership'
echo '==================================================='

	for CURFILE in `find /var/yp -type f`;  do
    		CUROWN=`stat -c %U $CURFILE`;
    		if [ "$CUROWN" != "root" -a "$CUROWN" != "root" -a "$CUROWN" != "bin" -a "$CUROWN" != "sys" -a "$CUROWN" != "system" ]; then
      			chown root:root $CURFILE
    		fi
  	done
fi
