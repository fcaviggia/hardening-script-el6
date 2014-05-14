#!/bin/sh

FIPSENABLE=$( cat /proc/sys/crypto/fips_enabled )
DRACUTFIPS=$( rpm -qa dracut-fips | grep -c fips )
SSHDFIPS=$( grep -c "Ciphers aes128-ctr,aes192-ctr,aes256-ctr" /etc/ssh/sshd_config )
SSHFIPS=$( grep -c "Ciphers aes128-ctr,aes192-ctr,aes256-ctr" /etc/ssh/ssh_config )

if [[ $FIPSENABLE -eq 0 && $DRACUTFIPS -eq 0 ]]; then
	yum install dracut-fips -y
	if [ $? -eq 0 ]; then
		DRACUTFIPS=1
	fi
fi

if [[ $FIPSENABLE -eq 0 && $DRACUTFIPS -eq 1 ]]; then
	sed -i 's/PRELINKING=yes/PRELINKING=no/g' /etc/sysconfig/prelink
	prelink -u -a
	dracut -f
	if [ -d /sys/firmware/efi ]; then
		BOOTDISK=`df /boot/efi | tail -1 | awk '{print $1 }'`
	else
		BOOTDISK=`df /boot | tail -1 | awk '{ print $1 }'`
	fi
	grubby --update-kernel=ALL --args="boot=$BOOTDISK fips=1"
fi

if [ $SSHDFIPS = 0 ]; then
	echo " " >> /etc/ssh/sshd_config
	echo "# For compliance of GEN000588 (FIPS 140-2)" >> /etc/ssh/sshd_config
	echo "Ciphers aes128-ctr,aes192-ctr,aes256-ctr" >> /etc/ssh/sshd_config
	echo "MACs hmac-sha1" >> /etc/ssh/sshd_config
fi

if [ $SSHFIPS = 0 ]; then
	echo " " >> /etc/ssh/ssh_config
	echo "# For compliance of GEN000588 (FIPS 140-2)" >> /etc/ssh/ssh_config
	echo "Ciphers aes128-ctr,aes192-ctr,aes256-ctr" >> /etc/ssh/ssh_config
	echo "MACs hmac-sha1" >> /etc/ssh/ssh_config
fi
