#!/bin/sh

## Any Micellenous Configurations 
echo '==================================================='
echo ' Additonal Hardening: Miscellenous Configurations'
echo '==================================================='

## DISA GEN000850
## Remember to add users to wheel group that need to su.
sed -i -re '/pam_wheel.so use_uid/s/^#//' /etc/pam.d/su

## DISA LNX000530
## Remove ACLs from sysctl.conf file
setfacl --remove-all /etc/sysctl.conf

## DISA LNX000720
## Turn on auditing in Kernel
/sbin/grubby --update-kernel=ALL --args="audit=1"

## Fix Audit Permissions
chmod -R 0600 /etc/audit/*
chmod -R -w /etc/audit/*
chmod 0700 /etc/audit

## Make SELinux configuration settings immutable
chattr +i /etc/selinux/config

#####  rsyslog (NIST 800-53: CCE-18095-0, CCE-18240-2, CCE-17857-4)
chmod 600 /etc/rsyslog.conf
chown root:root /etc/rsyslog.conf
setfacl --remove-all /etc/rsyslog.conf

###### gshadow (NIST 800-53: CCE-3932-1, CCE-4064-2, CCE-4210-1)
chmod 0000 /etc/gshadow
chown root:root /etc/gshadow
setfacl --remove-all /etc/gshadow

##### ONLY ROOT REBOOT OR SHUTDOWN
rm -f /etc/security/console.apps/{poweroff,shutdown,reboot,halt}
chmod 500 /sbin/{poweroff,shutdown,reboot,halt}
chown root:root /sbin/{poweroff,shutdown,reboot,halt}

##### Tomcat6
if [ -d /usr/share/tomcat6 ]; then
	chown -R tomcat:tomcat /usr/share/tomcat6
fi

##### Fix /dev/null Permssions
chmod 666 /dev/null

##### Add sshusers group
if [ $(grep -c sshusers /etc/group) -eq 0 ]; then
	/usr/sbin/groupadd sshusers &> /dev/null
fi

##### Add isso group (Auditors)
if [ $(grep -c isso /etc/group) -eq 0 ]; then
	/usr/sbin/groupadd isso &> /dev/null
fi

##### SUDO Access (Adds sudo access for wheel group and limited root role for isso group.)
chmod 0440 /etc/sudoers
chown root:root /etc/sudoers

##### Micelleneous Permission Fixes
chmod 0400 /etc/at.allow
chmod 0400 /etc/cron.allow
chmod 0400 /etc/crontab
chmod 0444 /etc/bashrc
chmod 0444 /etc/csh.cshrc
chmod 0444 /etc/csh.long
chmod 0600 /etc/ftpusers
chmod 0444 /etc/hosts
chmod 0444 /etc/networks
chmod 0400 /etc/securetty
chmod 0444 /etc/services
chmod 0444 /etc/shells
chmod 0600 /var/log/dmesg


##### VLOCK ALIAS
cat <<EOF > /etc/profile.d/vlock-alias.sh
#!/bin/sh
alias vlock='clear;vlock -a'
EOF

cat <<EOF > /etc/profile.d/vlock-alias.csh
#!/bin/csh
alias vlock 'clear;vlock -a'
EOF

chown root:root /etc/profile.d/vlock-alias.sh
chown root:root /etc/profile.d/vlock-alias.csh
chmod 755 /etc/profile.d/vlock-alias.sh
chmod 755 /etc/profile.d/vlock-alias.csh

##### CLEAN YUM
/usr/bin/yum clean all &>/dev/null

#### RESTORECON
/sbin/restorecon -R /etc
