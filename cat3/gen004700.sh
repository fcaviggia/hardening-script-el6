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
# on 05-Feb-2012 to fix sendmail service check even though this check is
# not needed.

#######################DISA INFORMATION###############################
#Group ID (Vulid): V-4694
#Group Title: Sendmail WIZ Command
#Rule ID: SV-4694r7_rule
#Severity: CAT III
#Rule Version (STIG-ID): GEN004700
#Rule Title: The Sendmail service must not have the wizard backdoor active.
#
#Vulnerability Discussion: Very old installations of the Sendmail mailing system contained a feature whereby a remote user connecting to the SMTP port can enter the WIZ command and be given an interactive shell with root privileges.
#
#Responsibility: System Administrator
#IAControls: ECSC-1
#
#Check Content: 
#Locate the sendmail.cf configuration file and check for "wiz" configuration.
#
#Procedure:
# find / -name sendmail.cf
# grep -v "^#" <sendmail.cf location> |grep -i wiz
#
#If an entry is found for wiz, this is a finding.
#
#Fix Text: If the WIZ command exists on sendmail then the version of sendmail is archaic and should be replaced with the latest version from RedHat.
#WIZ is not available on any sendmail distrubution of RHEL5. However,If the WIZ command is enabled on Sendmail, it should be disabled by adding this line to the sendmail.cf configuration file (note that it must be typed in uppercase):
#
#OW*
#
#For the change to take effect, kill the Sendmail process, refreeze the sendmail.cf file, and restart the Sendmail process.   
#######################DISA INFORMATION###############################

#Global Variables#
PDI=GEN004700

#Start-Lockdown

#This is off by default in RHEL 6

#Check if sendmail is installed
if [ -a '/etc/mail/sendmail.cf' ];  then
    #Check if wiz is enabled
    WIZON=$( cat /etc/mail/sendmail.cf |grep -v "^#" | grep -c wiz )
    if [ $WIZON -ne 0 ]; then
        sed -i "/wiz/d" /etc/mail/sendmail.cf
        
	echo '==================================================='
	echo ' Patching GEN004700: Sendmail WIZ Command'
	echo '==================================================='

        #Check if sendmail service is running
        service sendmail status | grep 'is running' > /dev/null
        if [ $? -eq 0 ]; then
       		service sendmail restart > /dev/null
        fi
    fi
fi

