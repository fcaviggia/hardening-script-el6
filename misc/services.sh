#!/bin/bash

echo '==================================================='
echo ' Additional Hardening: Disable Services (CATCH-ALL)'
echo '==================================================='

### Disable Services
OFFSRV="abrt-ccpp abrt-oops abrtd anacron atd apmd autofs avahi-daemon avahi-dnsconfd bluetooth cups dovecot firstboot gpm haldaemon hidd hplip ip6tables irda isdn kdump kudzu lm_sensors mcstrans mdmonitor microcode_ctl nfs nfslock portmap procmail portreserve qpidd rpcgssd rpcbind rpcidmap rpcsvcgssd rawdevices readahead_early readahead_later rhnsd restorecond setroubleshoot snmpd squid smb nmb sssd sysstat wpa_supplicant xfs xinetd sendmail"

for SRV in $OFFSRV; do
	if [ `/sbin/chkconfig --list | grep -c $SRV` -gt 0 ]; then
		echo "Disabling $SRV Service."
		/sbin/chkconfig $SRV off &> /dev/null
		/sbin/service $SRV stop &> /dev/null
	fi
done

### Enable Services
ONSRV="auditd postfix iptables rsyslog"

for SRV in $ONSRV; do
	if [ `/sbin/chkconfig --list | grep -c $SRV` -gt 0 ]; then
		echo "Enabling $SRV Service."
		/sbin/chkconfig $SRV on &> /dev/null
		/sbin/service $SRV start &> /dev/null
	fi
done

### Unsure
UNSURE="pcscd"
