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
#  - Updated by Shannon Mitchell (shannon.mitchell@fusiontechnology-llc.com) on
# 08-jan-2012 to run checks from /etc/passwd info to get around issues caused
# by pwck. Fixed to only check for assignment and set up GEN001460 to take care
# of missing home directory creation. 



#######################DISA INFORMATION###############################
#Group ID (Vulid): V-899
#Group Title: Assign Home Directories
#Rule ID: SV-27188r1_rule
#Severity: CAT III
#Rule Version (STIG-ID): GEN001440
#Rule Title: All interactive users must be assigned a home directory in the /etc/passwd file.
#
#Vulnerability Discussion: If users do not have a valid home directory, there is no place for the storage and control of files they own.
#
#
#Responsibility: System Administrator
#IAControls: ECSC-1
#
#Check Content: 
#Use pwck to check that home directory assignments are present.
# pwck
#If any user is not assigned a home directory, this is a finding.
#
#Fix Text: Assign a home directory to any user without one.   
#######################DISA INFORMATION###############################
echo '==================================================='
echo ' Patching GEN001440: Assign User Home Directories'
echo '==================================================='

#Global Variables#
PDI=GEN001440

# This check is just for assignments of a home directory for that user and
# the actual missing home directory creation is covered in GEN001460.sh.

#Start-Lockdown
# Loop through the passwd file.  Only print username, uid, gid and homedir. The
# gecos field tends to have spaces which will break the for loop as I currently
# have it.
for CURLINE in `awk -F ':' '{print $1":"$3":"$4":"$6}' /etc/passwd`; do

   # Break the line into an array
   STR_ARRAY=(`echo $CURLINE | tr ":" "\n"`)

   # Assign array elements to variables to make script easier to read
   CURUSER=${STR_ARRAY[0]}
   CURUID=${STR_ARRAY[1]}
   CURGID=${STR_ARRAY[2]}
   CURHOMEDIR=${STR_ARRAY[3]}

   # If and only if the home directory doesn't exist, create it and modify the
   # permissions on it.  
   if [ "$CURHOMEDIR" = "" ]; then
	usermod -d "/home/${CURUSER}" $CURUSER
   fi
done

