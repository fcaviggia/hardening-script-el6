#!/bin/sh
#
# Script: checkpoint (part of system-hardening)
# Description: Retain current configuration files in config
# License: GPL (see COPYING)
# Copyright: Red Hat Consulting, Sep 2013
# Author: Frank Caviggia <fcaviggi (at) redhat.com>

# Determine the Path
function realpath() {
    local r=$1; local t=$(readlink $r)
    while [ $t ]; do
        r=$(cd $(dirname $r) && cd $(dirname $t) && pwd -P)/$(basename $t)
        t=$(readlink $r)
    done
echo $r
}

# GLOBAL VARIABLES
BASE_DIR=`dirname $(realpath $0)`
BASE_BACKUP=$BASE_DIR/backups
BASE_CONFIG=$BASE_DIR/config

# USAGE STATEMENT
usage() {
cat << EOF
usage: $0 [options]

  -h 	Show this message

RHEL 6 Hardening Script

Checkpoints current configuration files in the 'config' directory to
overwriting the current configuration in a reapplication of the hardening
scripts. The previous configuration will be archived before scripts 
are copied to the 'config' directory.

EOF
}

# APPLY SYSTEM CONFIGURATION
apply_configuration() {
	echo -ne "\033[1mProceed with system configuration checkpoint?\033[0m [y/n]: "
	while read a; do
		case "$a" in
		y|Y)	break;;
		n|N)	exit 2;;
		*)	echo -n "[y/n]: ";;
		esac
	done

	tar czfp $BASE_BACKUP/`hostname -s`-configuration-`date +%Y%m%d`.tar.gz $BASE_CONFIG &> /dev/null

	#### ISSUE
	cp -f /etc/issue $BASE_CONFIG/issue

	#### SSH CONIFIGURATION
	cp -f /etc/ssh/sshd_config $BASE_CONFIG/sshd_config

	#### KERNEL PARAMETERS
	cp /etc/sysctl.conf $BASE_CONFIG/sysctl.conf

	#### USER AND PASSWORD CONFIGURATIONS
	cp -f /etc/security/limits.conf $BASE_CONFIG/limits.conf
	cp -f /etc/login.defs $BASE_CONFIG/login.defs

	#### EXAMPLE SAMBA CONFIGURATION
	cp -f /etc/samba/smb.conf $BASE_CONFIG/smb.confg &> /dev/null

	#### AUDITING RULES
	cp -f /etc/audit/auditd.conf $BASE_CONFIG/auditd.conf
	cp -f /etc/audit/audit.rules $BASE_CONFIG/audit.rules

	#### EXAMPLE FTP CONFIGURATION
	cp -f /etc/vsftpd/vsftpd.conf $BASE_CONFIG/vsftpd.conf

	#### FIREWALL CONFIGURATIONS (IPV4/IPV6)
	cp -f /etc/sysconfig/iptables $BASE_CONFIG/iptables
	cp -f /etc/sysconfig/ip6tables $BASE_CONFIG/ip6tables

	#### PAM CONFIGURATIONS
	cp -f /etc/pam.d/system-auth-local $BASE_CONFIG/system-auth-local
	cp -f /etc/pam.d/password-auth-local $BASE_CONFIG/password-auth-local
	cp -f /etc/pam.d/gnome-screensaver $BASE_CONFIG/gnome-screensaver

	##### SUDO CONFIGURATION (isso role, sudo access for wheel)
	cp -f /etc/sudoers $BASE_CONFIG/sudoers

	##### LOGROTATE (DAILY)
	cp -f /etc/logrotate.conf $BASE_CONFIG/logrotate.conf

	#### NTP CONFIGURATIONS
	cp -f /etc/ntp.conf $BASE_CONFIG/ntp.conf

	#### KERBEROS CONFIGURATIONS
	cp -f /etc/krb5.conf $BASE_CONFIG/krb5.conf

	#### TCP_WRAPPERS CONFIGURATIONS
	cp -f /etc/hosts.allow $BASE_CONFIG/hosts.allow
	cp -f /etc/hosts.deny $BASE_CONFIG/hosts.deny
	
	/usr/bin/logger -p security.info "System Configuraiton Checkpointed (system-hardening)"
}

# Check for root user
if [[ $EUID -ne 0 ]]; then
	if [ -z "$QUIET" ]; then
		echo
		tput setaf 1;echo -e "\033[1mPlease re-run this script as root!\033[0m";tput sgr0
	fi
	exit 1
fi

while getopts ":h" OPTION; do
	case $OPTION in
		h)
			usage
			exit 0
			;;
		?)
			echo "ERROR: Invalid Option Provided!"
			echo
			usage
			exit 1
			;;
	esac
done

apply_configuration

exit 0
