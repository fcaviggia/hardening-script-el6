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
#  - Updated by Shannon Mitchell(shannon.mitchell@fusiontechnology-llc.com)
# on 05-Feb-2012 to check for aliases before commenting them out.


#######################DISA INFORMATION###############################
#Group ID (Vulid): V-4691
#Group Title: Sendmail DECODE Command
#Rule ID: SV-4691r6_rule
#Severity: CAT I
#Rule Version (STIG-ID): GEN004640
#Rule Title: The SMTP service must not have a uudecode alias active.
#
#Vulnerability Discussion: A common configuration for older mail transfer agents (MTAs) is to include an alias for the decode user. All mail sent to this user is sent to the uudecode program, which automatically converts and stores files. By sending mail to the decode or the uudecode aliases that are present on some systems, a remote attacker may be able to create or overwrite files on the remote host. This could possibly be used to gain remote access.
#
#Responsibility: System Administrator
#IAControls: ECSC-1
#
#Check Content: 
#Check the SMTP service for an active "decode" command.
#
#Procedure:
# telnet localhost 25
#decode
#
#If the command does not return a 500 error code of command unrecognized, this is a finding.
#
#Fix Text: Disable mail aliases for decode and uudecode. If the /etc/aliases or /usr/lib/aliases (mail alias) file contains entries for these programs, remove them or disable them by placing # at the beginning of the line, and then executing the newaliases command. For more information on mail aliases, refer to the man page for aliases. Disabled aliases would be similar to these examples:
# decode: |/usr/bin/uudecode
# uudecode: |/usr/bin/uuencode -d   
#######################DISA INFORMATION###############################

#Global Variables#
PDI=GEN004640

#Start-Lockdown

rpm -q sendmail > /dev/null
if [ $? -eq 0 ]; then
echo '==================================================='
echo ' Patching GEN004640: Disable Sendmail DECODE'
echo '==================================================='

	grep '^decode' /etc/aliases > /dev/null
	if [ $? -eq 0 ]; then
		sed -i 's/^decode\:/\#decode\:/' /etc/aliases
		/usr/bin/newaliases > /dev/null
	fi

	grep '^uudecode' /etc/aliases > /dev/null
	if [ $? -eq 0 ]; then
		sed -i 's/^uudecode\:/\#uudecode\:/' /etc/aliases
		/usr/bin/newaliases > /dev/null
	fi
fi
