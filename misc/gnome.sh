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

	# NIST 800-53 CCE-3315-9 (row 95): Screensaver in 15 Minutes; Forced Logout in 30 Minutes (OPTIONAL)
	gconftool-2 --direct \
              --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
              --type int \
              --set /apps/gnome-screensaver/idle_delay 15
              
        gconftool-2 --direct \
              --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
              --type int \
              --set /desktop/gnome/session/idle_delay 15
              
	gconftool-2 --direct \
              --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
              --type string \
              --set /desktop/gnome/session/max_idle_action "none"
              # Require logout
              #--set /desktop/gnome/session/max_idle_action "logout"
              
	gconftool-2 --direct \
              --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
              --type int \
              --set /desktop/gnome/session/max_idle_time 120

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

	# Disable Ctrl-Alt-Del in GNOME
	gconftool-2 --direct \
	      --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
	      --type string \
	      --set /apps/gnome_settings_daemon/keybindings/power ""
	      
	# Enable screen locking via keystroke per RHEL6 V-38474
	gconftool-2 --direct \
	      --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
	      --type string \
	      --set /apps/gnome_settings_daemon/keybindings/screensaver "l"
	
	# Disable Clock Temperature
	gconftool-2 --direct \
	      --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
	      --type bool \
	      --set /apps/panel/applets/clock/prefs/show_temperature false

	# Disable Clock Weather
	gconftool-2 --direct \
	      --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
	      --type bool \
	      --set /apps/panel/applets/clock/prefs/show_weather false
fi
