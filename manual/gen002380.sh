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
# on 18-jan-2012 to document the suid findings and remove the suid removal bit.


#######################DISA INFORMATION###############################
#Group ID (Vulid): V-801
#Group Title: SUID Files Documentation
#Rule ID: SV-801r7_rule
#Severity: CAT II
#Rule Version (STIG-ID): GEN002380
#Rule Title: The owner, group-owner, mode, ACL, and location of files with the setuid bit set must be documented using site-defined procedures.
#
#Vulnerability Discussion: All files with the setuid bit set will allow anyone running these files to be temporarily assigned the UID of the file. While many system files depend on these attributes for proper operation, security problems can result if setuid is assigned to programs that allow reading and writing of files, or shell escapes. Only default vendor-supplied executables should have the setuid bit set.
#
#Responsibility: System Administrator
#IAControls: ECPA-1
#
#Check Content: 
#Files with the setuid bit set will allow anyone running these files to be temporarily assigned the user or group ID of the file. If an executable with setuid allows shell escapes, the user can operate on the system with the effective permission rights of the user or group owner.
#
#List all setuid files on the system.
#Procedure:
# find / -perm -4000 -exec ls -l {} \; | more
#
#Note: Executing these commands may result in large listings of files; the output may be redirected to a file for easier analysis.
#
#Ask the SA or IAO if files with the suid bit set have been documented. If any undocumented file has its suid bit set, this is a finding.
#
#Fix Text: Document the files with the suid bit set, or unset the suid bit on the executable.   
#######################DISA INFORMATION###############################

echo '==================================================='
echo ' Manual Check GEN001360: SUID File Permissions'
echo '==================================================='

#Global Variables#
PDI=GEN002380

#Start-Lockdown

# After testing, the list of SUID bits are going to be different based on
# what is initially installed on the system.  Also removing the SUID bit from
# all of files in the initial configure will break things and get you locked
# out of the box.  To start out with, we will just log all of the initial 
# findings in the /root directory with the other install logs, and review 
# the possiblity of removing the SUID bit after testing each to see if it
# can be done without breaking things.

find / -perm -4000 -exec ls -lZd {} \; > /root/initial_suid_bit_findings.log 2>/dev/null
less /root/initial_suid_bit_findings.log
