#!/bin/sh

echo '==================================================='
echo ' Patching GEN000140-x: System Baseline (AIDE)'
echo '==================================================='

AIDE=`rpm -q aide`
if [ $? -eq 0 ]; then
   if [ -e /var/lib/aide/aide.db.gz ]; then
   	echo "AIDE Previously Configured."
   else
	echo "Initializing AIDE database, this step may take quite a while!"
	# Send the following comment to STDERR - we want this to ALWAYS be seen
	echo "Waiting for AIDE database initialization to complete....." 1>&2
	/usr/sbin/aide --init &> /dev/null
	echo "AIDE database initialization complete."
	cp /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz

	if [ ! -d /var/log/aide/reports ]; then
		mkdir -p /var/log/aide/reports
		chmod 700 /var/log/aide/reports
		restorecon -R -v /var/log/aide/reports &>/dev/null
	fi

	if [ -e "/etc/cron.daily/aide.cron" ]; then
		grep -q aide /etc/cron.daily/aide.cron 2>/dev/null
		if [ $? -ne 0 ]; then
			echo '/usr/sbin/aide --check > /var/log/aide/reports/$HOSTNAME-AIDEREPORT-$(date +%Y%m%d).txt 2>&1' >> /etc/cron.daily/aide.cron
		fi
	else
		echo "#!/bin/bash" > /etc/cron.daily/aide.cron
		echo "# Configured to meet GEN000140-x" > /etc/cron.daily/aide.cron
		echo '/usr/sbin/aide --check > /var/log/aide/reports/$HOSTNAME-AIDEREPORT-$(date +%Y%m%d).txt 2>&1' >> /etc/cron.daily/aide.cron
		chmod 600 /etc/cron.daily/aide.cron
	fi
    fi
else
	echo "FINDING: AIDE NOT INSTALLED."
fi
