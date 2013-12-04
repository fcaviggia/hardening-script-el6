#!/bin/bash

## (GEN002200: CAT II) (Previously – G074) The SA will ensure the owner of all 
## shells is root or bin.
echo '==================================================='
echo ' Patching GEN002200: Set shell owners to root'
echo '==================================================='
for SHELL in `cat /etc/shells`; do
	chown root $SHELL
done
