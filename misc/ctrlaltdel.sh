#!/bin/sh

cat <<EOF > /etc/init/control-alt-delete.override
#  Note: the following line is NOT a comment
start on control-alt-delete
exec /usr/bin/logger -p security.info "Ctrl-Alt-Delete pressed"
EOF
