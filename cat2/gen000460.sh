#!/bin/sh

## (GEN000460: CAT II) (Previously – G013) The SA will ensure, after three consecutive
## failed logon attempts for an account, the account is locked for 15 minutes or until
## the SA unlocks the account.
echo '==================================================='
echo ' GEN000460: Disable after 3 consecutive'
echo '            failed attempts per account'
echo '==================================================='
cat <<EOF > /etc/pam.d/system-auth-ac
#%PAM-1.0
#
# pam.d/system-auth - PAM master configuration for CAPP/LSPP compliance
#		see the Evaluated Configuration Guide for more info
#
auth        required      pam_env.so
auth        sufficient    pam_fprintd.so
auth        required      pam_faillock.so preauth silent audit deny=3 even_deny_root
auth        sufficient    pam_unix.so try_first_pass
auth        [default=die] pam_faillock.so authfail audit deny=3
auth        sufficient    pam_faillock.so authsucc audit deny=3
auth        requisite     pam_succeed_if.so uid >= 500 quiet
auth        required      pam_deny.so

account     required      pam_unix.so
account     sufficient    pam_localuser.so
account     sufficient    pam_succeed_if.so uid < 500 quiet
account     required      pam_permit.so

password    required      pam_passwdqc.so min=disabled,disabled,16,12,8 random=42
password    sufficient    pam_unix.so sha512 shadow try_first_pass use_authtok
password    required      pam_deny.so

session     optional      pam_keyinit.so revoke
session     required      pam_limits.so
session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid
session     required      pam_unix.so
EOF

# auth config overwrites these changes, make it non executable
chmod ugo-x /usr/sbin/authconfig
