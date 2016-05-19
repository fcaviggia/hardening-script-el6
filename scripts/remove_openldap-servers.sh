#!/bin/bash
#
#V-38627
#
#Rule Title: The openldap-servers package must not be installed unless required.
# Unnecessary packages should not be installed to decrease the attack surface of the system.
#
#Check Content: 
# To verify the "openldap-servers" package is not installed, run the following command: 
#  rpm -q openldap-servers 
#
#Fix Text: 
# The "openldap-servers" package should be removed if not in use. 
# Is this machine the OpenLDAP server? If not, remove the package. 
#  yum erase openldap-servers  

echo '==================================================='
echo ' Patching V-38627: Remove openldap-servers Package'
echo '==================================================='


#Start-Lockdown
rpm -q openldap-servers > /dev/null
if [ $? -eq 0 ]; then
	rpm -e --nodeps openldap-servers 
fi
