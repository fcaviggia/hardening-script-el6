#/bin/sh

echo '==================================================='
echo ' Patching GEN000140-x: System Baseline (AIDE)'
echo '==================================================='

AIDE=`rpm -q aide`
if [ $? -eq 0 ]; then
	/usr/sbin/aide --init &> /dev/null
	cp /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz

	if [ -a "/var/spool/cron/root" ]; then
		grep -q aide /var/spool/cron/root 2>/dev/null
		if [ $? -ne 0 ]; then
			echo "0 0 * * 0		/usr/sbin/aide --check > /var/log/aide/reports/$HOSTNAME-AIDEREPORT.txt 2>&1" >> /var/spool/cron/root
		fi
	else
		if [ ! -d /var/log/aide/reports ]; then
			mkdir -p /var/log/aide/reports
			chmod 700 /var/log/aide/reports
			restorecon -R -v /var/log/aide/reports &>/dev/null
		fi
		
		echo "# Configured to meet GEN000140-x" > /var/spool/cron/root
		echo "0 0 * * 0     /usr/sbin/aide --check > /var/log/aide/reports/$HOSTNAME-AIDEREPORT.txt 2>&1" >> /var/spool/cron/root
		chmod 600 /var/spool/cron/root
	fi
else
	echo "FINDING: AIDE NOT INSTALLED."
fi
