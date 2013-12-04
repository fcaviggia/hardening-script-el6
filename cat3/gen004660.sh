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
#######################DISA INFORMATION###############################
#Group ID (Vulid): V-4692
#Group Title: Sendmail EXPN Command
#Rule ID: SV-4692r6_rule
#Severity: CAT III
#Rule Version (STIG-ID): GEN004660
#Rule Title: The SMTP service must not have the EXPN feature active.
#
#Vulnerability Discussion: The SMTP EXPN function allows an attacker to determine if an account exists on a system, providing significant assistance to a brute force attack on user accounts. EXPN may also provide additional information concerning users on the system, such as the full names of account owners.
#
#False Positives: 
#False positives may occur with the SMTP EXPN check. According to RFC821, it is acceptable for a server to respond with a 250 (success) or 550 (failure) when the server supports the EXPN command. For example, some servers return "550 EXPN command not available," meaning the command is not supported and the machine is not vulnerable. However, a result of "550 That is a mailing list, not a user" would be a failure code, but not an indication of an error, and the machine would be vulnerable. If you suspect that you have a false positive, check your log file for the response from the server.
#
#Responsibility: System Administrator
#IAControls: ECSC-1
#
#Check Content: 
#Determine if EXPN is disabled.
#
#Procedure:
# telnet localhost 25
#expn root
#
#If the command does not return a 500 error code of command unrecognized, this is a finding.
#
#or:
# grep -v "^#" /etc/mail/sendmial.cf |grep -i noexpn
#
#Check that the EXPN command is disabled with an entry in the sendmail.cf file that reads as follows: Opnoexpn, noexpn, or goaway.
#
#If the EXPN command is not disabled, this is a finding.
#
#Fix Text: Add the "noexpn" flag to /etc/mail/sendmail.cfo.
#
#Procedure:
#Edit the definition of "confPRIVACY_FLAGS" in /etc/mail/sendmail.mc to include "noexpn".
#
#Rebuild the sendmail.cf file with:
# make -C /etc/mail
#
#Restart the sendmail service.
# service sendmail restart
#######################DISA INFORMATION###############################

#Global Variables#
PDI=GEN004660

#Start-Lockdown

#Off by default in RHEL 5
if [ -e /etc/mail/sendmail.cf ]; then
	NOEXPN=$( grep -v "^#" /etc/mail/sendmail.cf |grep -ci noexpn )
	if [ $NOEXPN -eq 0 ]; then
		echo '==================================================='
		echo ' Patching GEN004660: Sendmail EXPN Command'
		echo '==================================================='
		sed -i '/.*O PrivacyOptions.*/s/$/,noexpn/' /etc/mail/sendmail.cf
	fi
fi
