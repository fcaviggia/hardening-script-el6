#!/bin/bash

## (GEN004440: CAT IV) (Previously – G133) The SA will ensure the sendmail 
## logging level (the detail level of e-mail tracing and debugging 
## information) in the sendmail.cf file is set to a value no lower than 
## nine (9).
echo '==================================================='
echo ' Patching GEN004440: Set sendmail logging level'
echo '==================================================='
if [ -e /etc/mail/sendmail.cf ]; then
	sed -i '/LogLevel/ c\O LogLevel=9' /etc/mail/sendmail.cf 
fi
