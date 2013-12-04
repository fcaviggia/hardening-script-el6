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
# on 09-jan-2011 to include an ACL check before running setfacl.  Added 
# support for lib64 dirs.
								     

#######################DISA INFORMATION###############################
#Group ID (Vulid): V-22317
#Group Title: GEN001310
#Rule ID: SV-26375r1_rule
#Severity: CAT II
#Rule Version (STIG-ID): GEN001310
#Rule Title: All library files must not have extended ACLs.
#
#Vulnerability Discussion: Unauthorized access could destroy the integrity of the library files.
#
#Responsibility: System Administrator
#IAControls: ECLP-1
#
#Check Content: 
#Check that system libraries have no extended ACLs.
# ls -lL /usr/lib/* /lib/* | grep "+ "
#If the permissions include a '+', the file has an extended ACL this is a finding.
#
#Fix Text: Remove the extended ACL from the file.
# setfacl --remove-all /usr/lib/* /lib/*   
#######################DISA INFORMATION###############################

echo '==================================================='
echo ' Patching GEN001310: Remove ACLs from Library Files'
echo '==================================================='

#Global Variables#
PDI=GEN001310

#Start-Lockdown
for LIBDIR in /usr/lib /usr/lib64 /lib /lib64; do
  if [ -d $LIBDIR ]; then
    for LIBFILE in `find $LIBDIR -type f \( -name *.so* -o -name *.a* \)`; do
      ACLOUT=`getfacl --skip-base $LIBFILE 2>/dev/null`;
      if [ "$ACLOUT" != "" ]; then
        setfacl --remove-all $LIBFILE
      fi
    done
  fi
done
