#!/bin/sh

## Ownership updates formerly found in misc.sh
echo '==================================================='
echo ' Additonal Hardening: Miscellenous ownership updates'
echo '==================================================='

## Fix Missing File Ownership
find / -nouser -print | xargs chown root
find / -nogroup -print | xargs chown :root
if [ ! -e /etc/cron.daily/unowned_files  ]; then
cat <<EOF > /etc/cron.daily/unowned_files
#!/bin/sh
# Fix user and group ownership of files without user
find / -nouser -print | xargs chown root
find / -nogroup -print | xargs chown :root
EOF
chown root:root /etc/cron.daily/unowned_files
chmod 0700 /etc/cron.daily/unowned_files
fi

