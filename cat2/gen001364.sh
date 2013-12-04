#!/bin/bash
######################################################################
#By Tummy a.k.a Vincent C. Passaro				     #
#Vincent[.]Passaro[@]gmail[.]com	         		     #
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
#  - Updated by Shannon Mitchell shannon.mitchell@fusiontechnology-llc.com)
# on 30-dec-2011 to check the permissions before running the chmod command.
								     

#######################DISA INFORMATION###############################
#Group ID (Vulid): V-22321
#Group Title: GEN001364
#Rule ID: SV-26397r1_rule
#Severity: CAT II
#Rule Version (STIG-ID): GEN001364
#Rule Title: The /etc/resolv.conf file must have mode 0644 or less permissive.
#
#Vulnerability Discussion: The resolv.conf (or equivalent) file configures the system's DNS resolver. DNS is used to resolve host names to IP addresses. If DNS configuration is modified maliciously, host name resolution may fail or return incorrect information. DNS may be used by a variety of system security functions such as time synchronization, centralized authentication, and remote system logging.
#
#Responsibility: System Administrator
#IAControls: ECLP-1
#
#Check Content: 
#Check the mode of the /etc/resolv.conf file.
# ls -l /etc/resolv.conf
#If the file mode is more permissive than 0644, this is a finding.
#
#Fix Text: Change the mode of the /etc/resolv.conf file to 0644 or less permissive.
# chmod 0644 /etc/resolv.conf   
#######################DISA INFORMATION###############################

#Global Variables#
PDI=GEN001364

#Start-Lockdown
if [ -a "/etc/resolv.conf" ]; then
echo '==================================================='
echo ' Patching GEN001364: /etc/resolv.conf Permissions'
echo '==================================================='
    # Pull the actual permissions
    FILEPERMS=`stat -L --format='%04a' /etc/resolv.conf`

    # Break the actual file octal permissions up per entity
    FILESPECIAL=${FILEPERMS:0:1}
    FILEOWNER=${FILEPERMS:1:1}
    FILEGROUP=${FILEPERMS:2:1}
    FILEOTHER=${FILEPERMS:3:1}

    # Run check by 'and'ing the unwanted mask(7133)
    if [ $(($FILESPECIAL&7)) != "0" ] || [ $(($FILEOWNER&1)) != "0" ] || [ $(($FILEGROUP&3)) != "0" ] || [ $(($FILEOTHER&3)) != "0" ]; then
        chmod u-xs,g-wxs,o-wxt /etc/resolv.conf
    fi
fi
