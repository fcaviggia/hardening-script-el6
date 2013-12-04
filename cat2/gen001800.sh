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
# on 14-jan-2012 to allow for "less permissive" permissions


#######################DISA INFORMATION###############################
#Group ID (Vulid): V-788
#Group Title: Default/Skeleton Dot Files Permissions
#Rule ID: SV-788r7_rule
#Severity: CAT II
#Rule Version (STIG-ID): GEN001800
#Rule Title: All skeleton files (typically those in /etc/skel) must have mode 0644 or less permissive.
#
#Vulnerability Discussion: If the skeleton files are not protected, unauthorized personnel could change user startup parameters and possibly jeopardize user files.
#
#Responsibility: System Administrator
#IAControls: ECLP-1
#
#Check Content: 
#Check skeleton files permissions.
# ls -alL /etc/skel
#If a skeleton file has a mode more permissive than 0644, this is a finding.
#
#Fix Text: Change the mode of skeleton files with incorrect mode:
#######################DISA INFORMATION###############################
echo '==================================================='
echo ' Patching GEN001800: Set permissions of default'
echo '                     skeleton files'
echo '==================================================='
#Global Variables#
PDI=GEN001800
BADSKELFILE=$( find /etc/skel -perm /7133 -type f )

#Start-Lockdown
for file in $BADSKELFILE; do
    chmod u-xs,g-wxs,o-wxt $file
done



