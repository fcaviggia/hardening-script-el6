#!/bin/sh

## BLACKLIST KERNEL MODULES 
echo '==================================================='
echo ' Additional Hardening: Blacklist Kernel Modules'
echo '==================================================='

if [ -e /etc/modprobe.d/usgcb-blacklist.conf ]; then
	rm -f /etc/modprobe.d/usgcb-blacklist.conf
fi
touch /etc/modprobe.d/usgcb-blacklist.conf
chmod 0644 /etc/modprobe.d/usgcb-blacklist.conf
chcon 'system_u:object_r:modules_conf_t:s0' /etc/modprobe.d/usgcb-blacklist.conf

# DISA GEN007660 - Disable Bluetooth
echo -e "install bluetooth /bin/false" >> /etc/modprobe.d/usgcb-blacklist.conf 
# DISA GEN007260 - Disable AppleTalk
echo -e "install appletalk /bin/false" >> /etc/modprobe.d/usgcb-blacklist.conf 
# NSA Recommendation: Disable mounting USB Mass Storage
echo -e "install usb-storage /bin/false" >> /etc/modprobe.d/usgcb-blacklist.conf
# Disable mounting of cramfs CCE-14089-7 (row 26)
echo -e "install cramfs /bin/false" >> /etc/modprobe.d/usgcb-blacklist.conf
# Disable mounting of freevxfs CCE-14457-6 (row 27)
echo -e "install freevxfs /bin/false" >> /etc/modprobe.d/usgcb-blacklist.conf
# Disable mounting of hfs CCE-15087-0 (row 28)
echo -e "install hfs /bin/false" >> /etc/modprobe.d/usgcb-blacklist.conf
# Disable mounting of hfsplus CCE-14093-9 (row 29)
echo -e "install hfsplus /bin/false" >> /etc/modprobe.d/usgcb-blacklist.conf
# Disable mounting of jffs2 CCE-14853-6 (row 30)
echo -e "install jffs2 /bin/false" >> /etc/modprobe.d/usgcb-blacklist.conf
# Disable mounting of squashfs CCE-14118-4 (row 31)
echo -e "install squashfs /bin/false" >> /etc/modprobe.d/usgcb-blacklist.conf
# Disable mounting of udf CCE-14871-8 (row 32)
echo -e "install udf /bin/false" >> /etc/modprobe.d/usgcb-blacklist.conf
# CCE-14268-7 (row 130) / DISA GEN007080
echo -e "install dccp /bin/false" >> /etc/modprobe.d/usgcb-blacklist.conf
# CCE-14235-5 (row 131) / DISA GEN007020
echo -e "install sctp /bin/false" >> /etc/modprobe.d/usgcb-blacklist.conf
#i CCE-14027-7 (row 132) / DISA GEN007480
echo -e "install rds /bin/false" >> /etc/modprobe.d/usgcb-blacklist.conf
# CCE-14911-2 (row 133) / DISA GEN007540
echo -e "install tipc /bin/false" >> /etc/modprobe.d/usgcb-blacklist.conf
# CCE-14948-4 (row 176)
echo -e "install net-pf-31 /bin/false" >> /etc/modprobe.d/usgcb-blacklist.conf
echo -e "install bluetooth /bin/false" >> /etc/modprobe.d/usgcb-blacklist.conf
# DISA GEN007700
echo -e "install net-pf-31 /bin/false" >> /etc/modprobe.d/usgcb-blacklist.conf
echo -e "options ipv6 disable=1" >> /etc/modprobe.d/usgcb-blacklist.conf
