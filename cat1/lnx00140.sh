#!/bin/sh

## (LNX00140: CAT I) (Previously – L072) The SA will configure the GRUB Console Boot
## Loader with a MD5 encrypted password.
echo '==================================================='
echo ' Checking LNX00140: GRUB Password'
echo '==================================================='
`/bin/grep password /boot/grub/grub.conf | /bin/grep -q encrypted`
if [ $? -gt 0 ]; then
        tput setaf 1;echo -e "\033[1mWARNING! WARNING! WARNING! WARNING! WARNING!\033[0m";tput sgr0
        tput setaf 1;echo -e "\033[1mGRUB IS NOT PASSWORD PROTECTED!\033[0m";tput sgr0
	tput setaf 1;echo -e "\033[1mWARNING! WARNING! WARNING! WARNING! WARNING!\033[0m";tput sgr0
fi
