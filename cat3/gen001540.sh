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
# on 14-jan-2012 to modify user check for users >= 500, fixed the dotfiles to
# be excluded and added the fix to the find.


#######################DISA INFORMATION###############################
#Group ID (Vulid): V-914
#Group Title: Home Directories File Ownership
#Rule ID: SV-914r7_rule
#Severity: CAT III
#Rule Version (STIG-ID): GEN001540
#Rule Title: All files and directories contained in interactive user home directories must be owned by the home directory's owner.
#
#Vulnerability Discussion: If users do not own the files in their directories, unauthorized users may be able to access them. Additionally, if files are not owned by the user, this could be an indication of system compromise.
#
#Responsibility: System Administrator
#IAControls: ECCD-1, ECCD-2
#
#Check Content: 
#For each user in the /etc/passwd file, check for the presence of files and directories within the user's home directory that are not owned by the home directory owner.
#
#Procedure:
# find /<usershomedirectory> ! -fstype nfs ! -user <username> ! \( -name .login -o -name .cshrc -o -name .logout -o -name .profile -o -name .bash_profile -o -name .bbashrc -o -name .env -o -name .dtprofile -o -name .dispatch -o -name .emacs -o -name .exrc \) -exec ls -ld {} \;
#
#If user home directories contain files or directories not owned by the home directory owner, this is a finding.
#
#Fix Text: Change the ownership of files and directories in user home directories to the owner of the home directory.
#
#Procedure:
# chown accountowner filename   _
#######################DISA INFORMATION###############################

echo '==================================================='
echo ' Patching GEN001540: Home Directories File Ownership'
echo '==================================================='

#Global Variables#
PDI=GEN001540

#Start-Lockdown
DotFiles='( -name .cshrc
                -o -name  .login
                -o -name  .logout
                -o -name  .profile
                -o -name  .bash_profile
                -o -name  .bbashrc
                -o -name  .env
                -o -name  .dtprofile
                -o -name  .dispatch
                -o -name  .emacs
                -o -name  .exrc )'

for UserName in `awk -F':' '!/nfsnobody/{if($3 >= 500) print $1}' /etc/passwd`; do
    if [ `echo $UserName | cut -c1` != '+' ]; then
        PwTest=`grep "^${UserName}:" /etc/passwd | cut -d: -f6`
        PwHomeDir=${PwTest:-NOVALUE}
        if [ "${PwHomeDir}" != "NOVALUE" -a "${PwHomeDir}" != " " ]; then
            if [ -d ${PwHomeDir} ]; then
                if [ ${PwHomeDir} = '/' ]; then
                    echo 'WARNING:  Home directory for "'${UserName}'"' \
                    '("'${PwHomeDir}'") excluded from check.'
                else

                    PWUID=`grep "^${UserName}:" /etc/passwd | cut -d: -f3`
		    # The rules says 'all' files and directories so here we go
		    # -xdev keeps it on the same filesystem
		    # ! -user ${UserName}:  is not owned by homedir user
		    # ! -fstype nfs: keep from changing nfs filesystem files ?
		    # ! ${DotFiles}: do not check the . user init files ?
		    find ${PwHomeDir} -xdev ! -user ${UserName} ! -fstype nfs  ! ${DotFiles} -exec chown ${UserName} {} \;

                fi
            fi
        fi
    fi
done

