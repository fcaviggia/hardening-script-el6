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
#Group ID (Vulid): V-910
#Group Title: Run Control Scripts World Writable Scripts
#Rule ID: SV-910r6_rule
#Severity: CAT I
#Rule Version (STIG-ID): GEN001640
#Rule Title: Run control scripts must not execute world-writable programs or scripts.
#
#Vulnerability Discussion: World-writable files could be modified accidentally or maliciously to compromise system integrity.
#
#Responsibility: System Administrator
#IAControls: ECCD-1, ECCD-2
#
#Check Content: 
#Check the permissions on the files or scripts executed from system startup scripts to see if they are world-writable.
#
#Procedure:
# more <startup script>
# ls -lL <script or executable referenced by startup script>
#
#or:
#Get the paths to files referenced by initialization scripts.
#Show the info for each file if it exists
#
# for FILE in `egrep -r "/" /etc/rc.* /etc/init.d|awk '/^.*[^\/][0-9A-Za-z_\/]*/{print $2}'|egrep "^/"|sort|uniq`;do if [ -e $FILE ]; then stat -L -c '%a:%n' $FILE;fi;done;egrep "^[0-7]{2,3}[2367]:"
#
#Alternatively, obtain a list of all world-writable files on the system and check system startup scripts to determine if any are referenced.
#
#Procedure:
# find / -perm -002 -type f > wwlist
#
#If any system startup script executes any file or script that is world-writable, this is a finding.
#
#Fix Text: Remove the world-writable permission from programs or scripts executed by run control scripts.
#
#Procedure:
# chmod o-w <program or script executed from run control script>   
#######################DISA INFORMATION###############################

echo '==================================================='
echo ' Patching GEN001640: Remove Write Permission from'
echo ' Scripts'
echo '==================================================='

#Global Variables#
PDI=GEN001640
WWWSTARTFILE=$( for FILE in `egrep -r "/" /etc/rc.* /etc/init.d|awk '/^.*[^\/][0-9A-Za-z_\/]*/{print $2}'|egrep "^/"|sort|uniq`; do if [ -e $FILE ]; then stat -L -c '%a:%n' $FILE | egrep "^[0-7]{2,3}[2367]:" | cut -d ":" -f 2 ; fi; done )

#Start-Lockdown

for file in $WWWSTARTFILE; do
    chmod o-w $file
done





