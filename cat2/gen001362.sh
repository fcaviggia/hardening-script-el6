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
#  - Updated by Shannon Mitchell(shannon.mitchell@fusiontechnology-llc.com) on 
# 30-dec-2011.  Added a check for existing permissions before making a change.
								     

#######################DISA INFORMATION###############################
#Group ID (Vulid): V-22319
#Group Title: GEN001362
#Rule ID: SV-26395r1_rule
#Severity: CAT II
#Rule Version (STIG-ID): GEN001362
#Rule Title: The /etc/resolv.conf file must be owned by root.
#
#Vulnerability Discussion: The resolv.conf (or equivalent) file configures the system's DNS resolver. DNS is used to resolve host names to IP addresses. If DNS configuration is modified maliciously, host name resolution may fail or return incorrect information. DNS may be used by a variety of system security functions such as time synchronization, centralized authentication, and remote system logging.
#
#
#Responsibility: System Administrator
#IAControls: ECLP-1
#
#Check Content: 
#Check that the /etc/resolv.conf file is owned by root.
# ls -l /etc/resolv.conf
#If the file is not owned by root, this is a finding.
#
#Fix Text: Change the owner of the /etc/resolv.conf file to root.
# chown root /etc/resolv.conf    
#######################DISA INFORMATION###############################

#Global Variables#
PDI=GEN001362

#Start-Lockdown

if [ -a "/etc/resolv.conf" ]; then
echo '==================================================='
echo ' Patching GEN001362: /etc/resolve.conf Ownership'
echo '==================================================='
  CUROWN=`stat -c %U /etc/resolv.conf`;
  if [ "$CUROWN" != "root" ]; then
      chown root /etc/resolv.conf
  fi
fi


