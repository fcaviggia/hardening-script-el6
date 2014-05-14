#!/bin/sh

## (LNX00580: CAT I) (Previously – L222) The SA will disable the
## Ctrl-Alt-Delete sequence unless the system is located in a controlled
## access area accessible only by SAs.
echo '==================================================='
echo ' Patching LNX00580: Disable CTRL-ALT-DELETE'
echo '==================================================='

cat > /etc/init/control-alt-delete.conf << EOF
#
# This task is run whenever the Control-Alt-Delete key combination is
# pressed.  Usually used to shut down the machine.

start on control-alt-delete

exec /usr/bin/logger -p security.info "Control-Alt-Delete pressed"
EOF
