#!/bin/bash

##################### Fusion Technology LLC #############################
# By Shannon Mitchell                                                   #
# Fusion Technology LLC                                                 #
# Shannon[.]Mitchell[@]fusiontechnology-llc[.]com                       #
# www.fusiontechnology-llc.com                                          #
##################### Fusion Technology LLC #############################
#
#  _____________________________________________________________________
# |  Version |   Change Information  |      Author        |    Date    |
# |__________|_______________________|____________________|____________|
# |    1.0   |   Initial Script      | Shannon Mitchell   | 18-jan-2012|
# |          |   Creation            |                    |            |
# |__________|_______________________|____________________|____________|
#	                                                                  
   
	
#######################DISA INFORMATION##################################
# Group ID (Vulid): V-802
# Group Title: SGID Files Documentation
# Rule ID: SV-802r7_rule
# Severity: medium
# Rule Version (STIG-ID): GEN002440
# Rule Title: The owner, group-owner, mode, ACL and location of files 
# with the setgid bit set must be documented using site-defined procedures.
#
# Vulnerability Discussion: All files with the setgid bit set will allow 
# anyone running these files to be temporarily assigned the GID of the 
# file. While many system files depend on these attributes for proper 
# operation, security problems can result if setgid is assigned to programs 
# that allow reading and writing of files, or shell escapes.
#
# Responsibility: System Administrator
# IAControls: ECPA-1
#
# Check Content:
#
# Locate all setgid files on the system.

# Procedure:
# find /  -perm -2000

# If the ownership, permissions, and location, and ACLs of all files with 
# the setgid bit set are not documented, this is a finding.
#
# Fix Text: 
#
# All files with the sgid bit set will be documented in the system 
# baseline and authorized by the Information Systems Security Officer.  
# Locate all sgid files with the following command: find / -perm -2000 
# -exec ls -ld {} ;\.   Ensure sgid files are part of the operating system 
# software, documented application software, documented utility software, 
# or documented locally developed software.  Ensure that none are text 
# files or shell programs.  
#######################DISA INFORMATION##################################

echo '==================================================='
echo ' Manual Check GEN002440: SGID Files Documentation'
echo '==================================================='

# Global Variables
PDI=GEN002440
	
# Start-Lockdown
find / -perm -2000 -exec ls -lZd {} \; > $PDI-findings.log 2>/dev/null
less $PDI-findings.log
