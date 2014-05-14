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
#Group ID (Vulid): V-4693
#Group Title: Sendmail VRFY Command
#Rule ID: SV-4693r7_rule
#Severity: CAT III
#Rule Version (STIG-ID): GEN004680
#Rule Title: The SMTP service must not have the VRFY feature active.
#
#Vulnerability Discussion: The VRFY (Verify) command allows an attacker to determine if an account exists on a system, providing significant assistance to a brute force attack on user accounts. VRFY may provide additional information about users on the system, such as the full names of account owners.
#
#Responsibility: System Administrator
#IAControls: ECSC-1
#
#Check Content: 
#Determine if VRFY is disabled.
#
#Procedure:
# telnet localhost 25
#vrfy root
#
#If the command does not return a 500 error code of command unrecognized, this is a finding.
#
#or:
# grep -v "^#" /etc/mail/sendmail.cf |grep -i vrfy
#
#Check that the VRFY command is disabled with an entry in the sendmail.cf file. The entry could be any one of "Opnovrfy", "novrfy", or "goaway", which could also have other options included, such as "noexpn". The "goaway" argument encompasses many things, such as "novrfy" and "noexpn".
#
#If no setting to disable VRFY is found, this is a finding.
#
#Fix Text: Add the "novrfy" flag to your Sendmail in /etc/sendmail.cf.
#
#Procedure:
#Edit the definition of "confPRIVACY_FLAGS" in /etc/mail/sendmail.mc to include "novrfy".
#
#Rebuild the sendmail.cf file with:
# make -C /etc/mail
#
#Restart the sendmail service.
# service sendmail restart 
#######################DISA INFORMATION###############################

#Global Variables#
PDI=GEN004680

#Start-Lockdown
#Off by default in RHEL 5
if [ -e /etc/mail/sendmail.cf ]; then
	NOVRFY=$( grep -v "^#" /etc/mail/sendmail.cf |grep -ci novrfy )
	if [ $NOVRFY -eq 0 ]; then
		echo '==================================================='
		echo ' Patching GEN004640: Sendmail VRFY Command'
		echo '==================================================='

		sed -i '/.*O PrivacyOptions.*/s/$/,novrfy/' /etc/mail/sendmail.cf
	fi
fi
