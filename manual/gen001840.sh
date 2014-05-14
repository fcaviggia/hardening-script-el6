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
# on 01-jan-2012 to add checks.  Moved script from the dev to the prod 
# directory.
#
#  - Updated by Shannon Mitchell on 14-jan-2012 to fix an issue with quoted
# paths.




#######################DISA INFORMATION###############################
#Group ID (Vulid): V-11985
#Group Title: Global Initialization Files PATH Variable
#Rule ID: SV-12486r5_rule
#Severity: CAT II
#Rule Version (STIG-ID): GEN001840
#Rule Title: All global initialization files' executable search paths must contain only absolute paths.
#
#Vulnerability Discussion: The executable search path (typically the PATH environment variable) contains a list of directories for the shell to search to find executables. If this path includes the current working directory or other relative paths, executables in these directories may be executed instead of system commands. This variable is formatted as a colon-separated list of directories. If there is an empty entry, such as a leading or trailing colon, or two consecutive colons, this is interpreted as the current working directory. Paths starting with a slash (/) are absolute paths.
#
#Responsibility: System Administrator
#IAControls: ECCD-1, ECCD-2
#
#Check Content: 
#Check the global initialization files' executable search paths.
# grep PATH /etc/profile /etc/bashrc /etc/csh.login /etc/csh.cshrc /etc/environment /etc/.login /etc/security/environ /etc/profile.d/*
#This variable is formatted as a colon-separated list of directories. If there is an empty entry, such as a leading or trailing colon, or two consecutive colons, this is a finding. If an entry begins with a character other than a slash (/) this is a relative path, this is a finding.
#
#
#Fix Text: Edit the global initialization file(s) with PATH variables containing relative paths. Edit the file and remove the relative path from the PATH variable.   
#######################DISA INFORMATION###############################

echo '==================================================='
echo ' Patching GEN001840: Global Initialization Files'
echo '                     PATH Variable'
echo '==================================================='

#Global Variables#
PDI=GEN001840

#Start-Lockdown

for INITFILE in /etc/profile /etc/bashrc /etc/csh.login /etc/csh.cshrc /etc/environment /etc/.login /etc/security/environ `ls /etc/profile.d/*` /etc/csh.login /etc/csh.cshrc; do
  if [ -e $INITFILE ]; then

    ## Check bash style settings

    # Remove leading colons
    egrep '[^_]*PATH=:' $INITFILE > /dev/null
    if [ $? -eq 0 ]; then
   	sed -i -e 's/[^_]*PATH=:/PATH=/g' $INITFILE
    fi

    # remove trailing colons
    egrep '[^_]*PATH=.*:\"*\s*$' $INITFILE > /dev/null
    if [ $? -eq 0 ]; then
    	sed -i -e 's/\([^_]*PATH=.*\):\(\"*\s*$\)/\1\2/g' $INITFILE
    fi

    # remove begin/end colons with no data
    egrep '[^_]*PATH=.*::.*' $INITFILE > /dev/null
    if [ $? -eq 0 ]; then
 	sed -i -e '/[^_]*PATH=/s/::/:/g' $INITFILE
    fi

    # remove anything that doesn't start with a $ or /
    egrep '[^_]*PATH="' $INITFILE > /dev/null
    if [ $? -eq 0 ]; then

      egrep '[^_]*PATH="[^$/]' $INITFILE > /dev/null
      if [ $? -eq 0 ]; then
	    sed -i -e '/[^_]*PATH/s/="[^$/][^:]*:*/="/g' $INITFILE
      fi
   
    else

      # remove anything that doesn't start with a $ or /
      egrep '[^_]*PATH=[^$/]' $INITFILE > /dev/null
      if [ $? -eq 0 ]; then
 	    sed -i -e '/[^_]*PATH/s/=[^$/][^:]*:*/=/g' $INITFILE
      fi

    fi

    egrep '[^_]*PATH=.*:[^$/:][^:]*\s*' $INITFILE > /dev/null
    if [ $? -eq 0 ]; then
            sed -i -e '/[^_]*PATH=/s/:[^$/:][^:]*//g' $INITFILE
    fi

    ## Check csh style settings

    # Remove leading colons
    egrep 'setenv PATH ":' $INITFILE > /dev/null
    if [ $? -eq 0 ]; then
         sed -i -e 's/setenv PATH ":/setenv PATH "/g' $INITFILE
    fi

    # remove trailing colons
    egrep 'setenv PATH ".*:"' $INITFILE > /dev/null
    if [ $? -eq 0 ]; then
         sed -i -e 's/\(setenv PATH ".*\):\("\)/\1\2/g' $INITFILE
    fi

    # remove begin/end colons with no data
    egrep 'setenv PATH ".*::.*' $INITFILE > /dev/null
    if [ $? -eq 0 ]; then
        sed -i -e '/setenv PATH/s/::/:/g' $INITFILE
    fi

    # remove anything that doesn't start with a $ or /
    egrep 'setenv PATH ".*:[^$/:][^:]*\s*' $INITFILE > /dev/null
    if [ $? -eq 0 ]; then
        sed -i -e '/setenv PATH/s/:[^$/:][^:"]*//g' $INITFILE
    fi

    egrep 'setenv PATH "[^$/]' $INITFILE > /dev/null
    if [ $? -eq 0 ]; then
        sed -i -e '/setenv PATH/s/"[^$/][^:"]*:*/"/g' $INITFILE
    fi

  fi

done

