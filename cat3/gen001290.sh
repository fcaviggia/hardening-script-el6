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
#  - Updated by Shannon Mitchell(shannon.mitchell@fusiontechnology-llc.com)
# on 09-jan-2011 to include an ACL check before running setfacl.
								     

#######################DISA INFORMATION###############################
#Group ID (Vulid): V-22316
#Group Title: GEN001290
#Rule ID: SV-26371r1_rule
#Severity: CAT III
#Rule Version (STIG-ID): GEN001290
#Rule Title: All manual page files must not have extended ACLs.
#
#Vulnerability Discussion: If manual pages are compromised, misleading information could be inserted, causing actions that may compromise the system.
#
#Responsibility: System Administrator
#IAControls: ECLP-1
#
#Check Content: 
#Check that all manual page files have no extended ACLs.
# ls -lL /usr/share/man /usr/share/info /usr/share/infopage
#If the permissions include a '+', the file has an extended ACL this is a finding.
#
#Fix Text: Remove the extended ACL from the file.
# setfacl --remove-all /usr/share/man/* /usr/share/info/* /usr/share/infopage/*    
#######################DISA INFORMATION###############################

echo '==================================================='
echo ' Patching GEN001290: Remove ACLs from Man Pages'
echo '==================================================='

#Global Variables#
PDI=GEN001290

#Start-Lockdown
for MANDIR in /usr/share/man /usr/share/info /usr/share/infopage; do
  if [ -d $MANDIR ]; then
    for MANPAGEFILE in `find $MANDIR -type f`; do
      ACLOUT=`getfacl --skip-base $MANPAGEFILE 2>/dev/null`;
      if [ "$ACLOUT" != "" ]; then
        setfacl --remove-all $MANPAGEFILE
      fi
    done
  fi
done
