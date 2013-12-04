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
# on 14-Feb-2012 to move from dev to prod and add fix.
#
#  - Updated by Shannon Mitchell(shannon.mitchell@fusiontechnology-llc.com)
# on 18-Feb-2012 to add an iptables rule check before adding the new rules.


#######################DISA INFORMATION###############################
#Group ID (Vulid): V-4399
#Group Title: NIS/NIS+ implemented under UDP
#Rule ID: SV-4399r6_rule
#Severity: CAT I
#Rule Version (STIG-ID): GEN006380
#Rule Title: The system must not use UDP for NIS/NIS+.
#
#Vulnerability Discussion: Implementing NIS or NIS+ under UDP may 
#make the system more susceptible to a denial of service attack 
#and does not provide the same quality of service as TCP.
#
#Responsibility: System Administrator
#IAControls: ECSC-1
#
#Check Content: 
#If the system does not use NIS or NIS+, this is not applicable.
#
#Check if NIS or NIS+ is implemented using UDP.
#
#Procedure:
# rpcinfo -p | grep yp | grep udp
#
#If NIS or NIS+ is implemented using UDP, this is a finding.
#
#Fix Text: Configure the system to not use UDP for NIS and NIS+. Consult vendor documentation for the required procedure.   
#######################DISA INFORMATION###############################

#Global Variables#
PDI=GEN006380

#Start-Lockdown

# There is no built in way to do this, so lets go with redhat's recommendations
# for securing NIS and set a static port.  udp can be blocked with iptables.

rpm -q ypserv > /dev/null
if [ $? -eq 0 ]; then
echo '==================================================='
echo ' Patching GEN006380: NIS/NIS+ implemented under UDP'
echo '==================================================='

  grep 'YPSERV_ARGS' /etc/sysconfig/network > /dev/null
  if [ $? -eq 0 ]; then
    grep 'YPSERV_ARGS' /etc/sysconfig/network | grep '\-p 834' > /dev/null
    if [ $? -ne 0 ]; then
      sed -i -e 's/YPSERV_ARGS.*/YPSERV_ARGS="-p 834"/g' /etc/sysconfig/network
    fi
  else
    echo "# Setting static NIS port for STIG $PDI" >> /etc/sysconfig/network
    echo 'YPSERV_ARGS="-p 834"' >> /etc/sysconfig/network
  fi

  grep 'YPXFRD_ARGS' /etc/sysconfig/network > /dev/null
  if [ $? -eq 0 ]; then
    grep 'YPXFRD_ARGS' /etc/sysconfig/network | grep '\-p 835' > /dev/null
    if [ $? -ne 0 ]
    then
      sed -i -e 's/YPXFRD_ARGS.*/YPXFRD_ARGS="-p 835"/g' /etc/sysconfig/network
    fi
  else
    echo "# Setting static NIS port for STIG $PDI" >> /etc/sysconfig/network
    echo 'YPXFRD_ARGS="-p 835"' >> /etc/sysconfig/network
  fi

  grep 'INPUT \-p udp \-m udp \-\-dport 834 \-j DROP' /etc/sysconfig/iptables > /dev/null
  if [ $? -ne 0 ]; then
    service iptables start > /dev/null
    iptables -I INPUT 1 -p udp -m udp --dport 834 -j DROP
    service iptables save > /dev/null
  fi

  grep 'INPUT \-p udp \-m udp \-\-dport 835 \-j DROP' /etc/sysconfig/iptables > /dev/null
  if [ $? -ne 0 ]; then
    service iptables start > /dev/null
    iptables -I INPUT 1 -p udp -m udp --dport 835 -j DROP
    service iptables save > /dev/null
  fi
  service ypserv restart > /dev/null
fi
