#!/bin/sh

## FIX VARIOUS GNOME SETTINGS 
echo '==================================================='
echo ' Additional Hardening: Gnome Desktop Settings'
echo '==================================================='

if [ -x /usr/bin/gconftool-2 ]; then
	# Remove Red Hat Registration Reminder
	rm -f /etc/xdg/autostart/rhsm*desktop

	# Legal Banner on GDM
	gconftool-2 --direct \
              --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
              --type bool \
              --set /apps/gdm/simple-greeter/banner_message_enable true

	gconftool-2 --direct \
              --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
              --type string \
              --set /apps/gdm/simple-greeter/banner_message_text "$(cat /etc/issue)"

	# Disable User List on GDM
	gconftool-2 --direct \
              --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
              --type bool \
              --set /apps/gdm/simple-greeter/disable_user_list true

	# Disable Restart Buttons on GDM
	gconftool-2 --direct \
              --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
              --type bool \
              --set /apps/gdm/simple-greeter/disable_restart_buttons true

	# Lock Gnome Menus
	gconftool-2 --direct \
              --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
              --type bool \
              --set /apps/panel/global/locked_down true

	# Disable Printing in Gnome
	gconftool-2 --direct \
              --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
              --type bool \
              --set /desktop/gnome/lockdown/disable_printing true
	gconftool-2 --direct \
              --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
              --type bool \
              --set /desktop/gnome/lockdown/disable_print_setup true

	# Disable Quick User Switching in Gnome
	gconftool-2 --direct \
              --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
              --type bool \
              --set /desktop/gnome/lockdown/disable_user_switching true

	# Disable Gnome Power Settings
	gconftool-2 --direct \
              --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
              --type bool \
              --set /apps/gnome-power-manager/general/can_suspend false
	gconftool-2 --direct \
              --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
              --type bool \
              --set /apps/gnome-power-manager/general/can_hibernate false
	cat <<EOF > /etc/polkit-1/localauthority/50-local.d/lockdown.pkla
[consolekit]
Identity=unix-user:*
Action=org.freedesktop.consolekit.system.*
ResultAny=no
ResultInactive=no
ResultActive=no

[upower]
Identity=unix-user:*
Action=org.freedesktop.upower.system.*
ResultAny=no
ResultInactive=no
ResultActive=no

[devicekit]
Identity=unix-user:*
Action=org.freedesktop.devicekit.power.*
ResultAny=no
ResultInactive=no
ResultActive=no
EOF

	# NSA Recommendation: Disable Gnome Automounter
	gconftool-2 --direct \
              --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
              --type bool \
              --set /apps/nautilus/preferences/media_autorun_never true
	gconftool-2 --direct \
              --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
              --type bool \
              --set /apps/nautilus/preferences/media_automount_open false
	gconftool-2 --direct \
              --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
              --type bool \
              --set /apps/nautilus/preferences/media_automount false

	# NSA Recommendation: Disable Gnome Thumbnailers
	gconftool-2 --direct \
              --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
              --type bool \
              --set /desktop/gnome/thumbnailers/disable_all true

	# NIST 800-53 CCE-3315-9 (row 95): Screensaver in 15 Minutes; Forced Logout in 30 Minutes
	gconftool-2 --direct \
              --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
              --type string \
              --set /desktop/gnome/session/max_idle_action "forced-logout"
	gconftool-2 --direct \
              --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
              --type int \
              --set /desktop/gnome/session/max_idle_time 25
	gconftool-2 --direct \
              --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
              --type int \
              --set /apps/gnome-screensaver/idle_delay 15

	# NIST 800-53 CCE-14604-3 (row 96)
	gconftool-2 --direct \
              --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
              --type bool \
              --set /apps/gnome-screensaver/idle_activation_enabled true

	# NIST 800-53 CCE-14023-6 (row 97)
	gconftool-2 --direct \
              --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
              --type bool \
              --set /apps/gnome-screensaver/lock_enabled true

	# NIST 800-53 CCE-14735-5 (row 98)
	gconftool-2 --direct \
              --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
              --type string \
              --set /apps/gnome-screensaver/mode blank-only
              
	# Fix for gnome-screensaver
	cat <<EOF > /etc/pam.d/gnome-screensaver
#%PAM-1.0
auth    [success=done ignore=ignore default=bad] pam_selinux_permit.so
auth    required      pam_env.so
auth    required      pam_lastlog.so inactive=35
auth    required      pam_faillock.so preauth silent audit deny=3 even_deny_root root_unlock_time=900 unlock_time=604800 fail_interval=900
auth    sufficient    pam_unix.so try_first_pass
auth    [default=die] pam_faillock.so authfail audit deny=3 even_deny_root root_unlock_time=900 unlock_time=604800 fail_interval=900
auth    sufficient    pam_faillock.so authsucc audit deny=3 even_deny_root root_unlock_time=900 unlock_time=604800 fail_interval=900
auth    requisite     pam_succeed_if.so uid >= 500 quiet
auth    required      pam_deny.so

account required      pam_unix.so
account required      pam_faillock.so
account required      pam_lastlog.so inactive=35
account sufficient    pam_localuser.so
account sufficient    pam_succeed_if.so uid < 500 quiet
account required      pam_permit.so

#password required     pam_passwdqc.so min=disabled,disabled,16,12,8 random=42
password required     pam_cracklib.so try_first_pass retry=3 minlen=14 dcredit=-1 ucredit=-1 ocredit=-1 lcredit=-1 difok=4
password sufficient   pam_unix.so sha512 shadow try_first_pass use_authtok remember=24
password required     pam_deny.so

session required      pam_lastlog.so showfailed
session optional      pam_keyinit.so revoke
session required      pam_limits.so
session [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid
session required      pam_unix.so
EOF

fi
