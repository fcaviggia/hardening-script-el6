#!/bin/bash

#################################################
# Created by: Luke "Brisk-OH" Brisk-OH			#
# 10-27-2014									#
# luke.brisk@boeing.com or luke.brisk@gmail.com # 
################################################# 
#Group ID (Vulid):  V-38607
# Group Title:  SRG-OS-000112
# Rule ID:  SV-50408r1_rule
# Severity: CAT I
# Rule Version (STIG-ID):  RHEL-06-000227
# Rule Title: The SSH daemon must be configured to use only the SSHv2 protocol.
# Vulnerability Discussion:  SSH protocol version 1 suffers from design flaws that result in security vulnerabilities and should not be used.
#
# Check Content:  
# To check which SSH protocol version is allowed, run the following command: 
#
#grep Protocol /etc/ssh/sshd_config
#
# If configured properly, output should be 
#
# Protocol 2
#
# If it is not, this is a finding.
#
# Fix Text: Only SSH protocol version 2 connections should be permitted. The default setting in "/etc/ssh/sshd_config" is correct, and can be verified by ensuring that the following line appears: 
#
# Protocol 2   
#
# CCI: CCI-000774

echo '==================================================='
echo ' Patching RHEL-06-000227: The SSH daemon must be'
echo ' configured to use only the SSHv2 protocol.'
echo '==================================================='
if [ `grep -c "^Protocol" /etc/ssh/sshd_config` -gt 0 ]; then
	sed -i "/^Protocol/ c\Protocol 2" /etc/ssh/sshd_config
else
	echo "Protocol 2" >> /etc/ssh/sshd_config
fi

