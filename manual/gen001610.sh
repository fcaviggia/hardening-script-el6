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
#  - update by Shannon Mitchell(shannon.mitchell@fusiontechnology-llc.com
# on 14-jan-2012 to move from a manual check to an automated fix.


#######################DISA INFORMATION###############################
#Group ID (Vulid): V-22355
#Group Title: GEN001610
#Rule ID: SV-26464r1_rule
#Severity: CAT II
#Rule Version (STIG-ID): GEN001610
#Rule Title: Run control scripts' lists of preloaded libraries must contain only absolute paths.
#
#Vulnerability Discussion: The library preload list environment variable contains a list of libraries for the dynamic linker to load before loading the libraries required by the binary. If this list contains paths to libraries relative to the current working directory, unintended libraries may be preloaded. This variable is formatted as a space-separated list of libraries. Paths starting with a slash (/) are absolute paths.
#
#Responsibility: System Administrator
#IAControls: ECSC-1
#
#Check Content: 
#Check that run control scripts' library preload list.
# grep -r LD_PRELOAD /etc/rc* /etc/init.d
#This variable is formatted as a colon-separated list of paths. If there is an empty entry, such as a leading or trailing colon, or two consecutive colons, this is a finding. If an entry begins with a character other than a slash (/) this is a relative path, this is a finding.
#
#Fix Text: Edit the run control script and remove the relative path entry from the library preload variable.   
#######################DISA INFORMATION###############################

echo '==================================================='
echo ' Patching GEN001610: Remove LD_PRELOAD for' 
echo '                     Initilization Scripts'
echo '==================================================='

#Global Variables#
PDI=GEN001610

#Start-Lockdown
for INITFILE in `find /etc/rc.d/ -type f`; do

  if [ -e $INITFILE ]; then

    ## Check bash style settings

    # Remove leading colons
    egrep 'LD_PRELOAD=:' $INITFILE > /dev/null
    if [ $? -eq 0 ]; then
         sed -i -e 's/LD_PRELOAD=:/LD_PRELOAD=/g' $INITFILE
    fi

    # remove trailing colons
    egrep 'LD_PRELOAD=.*:\"*\s*$' $INITFILE > /dev/null
    if [ $? -eq 0 ]; then
         sed -i -e 's/\(LD_PRELOAD=.*\):\(\"*\s*$\)/\1\2/g' $INITFILE
    fi

    # remove begin/end colons with no data
    egrep 'LD_PRELOAD=.*::.*' $INITFILE > /dev/null
    if [ $? -eq 0 ]; then
         sed -i -e '/LD_PRELOAD=/s/::/:/g' $INITFILE
    fi

    # remove anything that doesn't start with a $ or /
    egrep 'LD_PRELOAD="' $INITFILE > /dev/null
    if [ $? -eq 0 ]; then 
    
      egrep 'LD_PRELOAD="[^$/]' $INITFILE > /dev/null
      if [ $? -eq 0 ]; then
           sed -i -e '/LD_PRELOAD/s/="[^$/][^:]*:*/="/g' $INITFILE
      fi
    
    else

      # remove anything that doesn't start with a $ or /
      egrep 'LD_PRELOAD=[^$/]' $INITFILE > /dev/null
      if [ $? -eq 0 ]; then
           sed -i -e '/LD_PRELOAD/s/=[^$/][^:]*:*/=/g' $INITFILE
      fi

    fi

    egrep 'LD_PRELOAD=.*:[^$/:][^:]*\s*' $INITFILE > /dev/null
    if [ $? -eq 0 ]; then 
         sed -i -e '/LD_PRELOAD=/s/:[^$/:][^:]*//g' $INITFILE
    fi

    ## Check csh style settings

    # Remove leading colons
    egrep 'setenv LD_PRELOAD ":' $INITFILE > /dev/null
    if [ $? -eq 0 ]; then
         sed -i -e 's/setenv LD_PRELOAD ":/setenv LD_PRELOAD "/g' $INITFILE
    fi

    # remove trailing colons
    egrep 'setenv LD_PRELOAD ".*:"' $INITFILE > /dev/null
    if [ $? -eq 0 ]; then
         sed -i -e 's/\(setenv LD_PRELOAD ".*\):\("\)/\1\2/g' $INITFILE
    fi

    # remove begin/end colons with no data
    egrep 'setenv LD_PRELOAD ".*::.*' $INITFILE > /dev/null
    if [ $? -eq 0 ]; then
         sed -i -e '/setenv LD_PRELOAD/s/::/:/g' $INITFILE
    fi

    # remove anything that doesn't start with a $ or /
    egrep 'setenv LD_PRELOAD ".*:[^$/:][^:]*\s*' $INITFILE > /dev/null
    if [ $? -eq 0 ]; then
         sed -i -e '/setenv LD_PRELOAD/s/:[^$/:][^:"]*//g' $INITFILE
    fi

    egrep 'setenv LD_PRELOAD "[^$/]' $INITFILE > /dev/null
    if [ $? -eq 0 ];  then
         sed -i -e '/setenv LD_PRELOAD/s/"[^$/][^:"]*:*/"/g' $INITFILE
    fi

  fi

done
