#!/bin/bash

#V-38471
#
#Rule Title: The system must forward audit records to the syslog service.
#
# The auditd service does not include the ability to send audit records to a centralized server for management 
# directly. It does, however, include an audit event multiplexor plugin (audispd) to pass audit records to the 
# local syslog server.
#
#Check Content: 
# Verify the audispd plugin is active: 
#  grep active /etc/audisp/plugins.d/syslog.conf 
# 
# If the "active" setting is missing or set to "no", this is a finding.
#
#Fix Text: 
# Set the "active" line in "/etc/audisp/plugins.d/syslog.conf" to "yes". Restart the auditd process. 
# service auditd restart

echo '==================================================='
echo ' Remediating: Forward audit records to the syslog service'
echo '==================================================='

#Start-Lockdown
if [ `grep -c "^[^#]*active" /etc/audisp/plugins.d/syslog.conf ` -gt 0 ]; then
	egrep 'active.*no' /etc/audisp/plugins.d/syslog.conf > /dev/null
	if [ $? -eq 0 ]; then
		sed -i "s/active = no/active = yes/" /etc/audisp/plugins.d/syslog.conf
	fi
	service auditd restart
else
	echo "#Adding for V-38471" >> /etc/audisp/plugins.d/syslog.conf
	echo "active = yes" >> /etc/audisp/plugins.d/syslog.conf
	service auditd restart
fi

