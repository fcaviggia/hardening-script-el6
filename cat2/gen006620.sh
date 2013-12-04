#!/bin/sh

## (GEN006620: CAT II) The SA will ensure an access control program (e.g.,
## TCP_WRAPPERS) hosts.deny and hosts.allow files (or equivalent) are used to
## grant or deny system access to specific hosts.
echo '==================================================='
echo ' Patching GEN006620: Set hosts.deny file'
echo '==================================================='
echo "ALL: ALL" > /etc/hosts.deny
echo "ALL: 127.0.0.1 [::1]" > /etc/hosts.allow
echo "sshd: ALL" >> /etc/hosts.allow
