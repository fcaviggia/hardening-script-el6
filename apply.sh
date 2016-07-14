#!/bin/sh
# This script was written by Frank Caviggia, Red Hat Consulting
# Last update was 25 July 2014
# This script is NOT SUPPORTED by Red Hat Global Support Services.
# Please contact Josh Waldman for more information.
#
# Script: apply.sh (system-hardening)
# Description: RHEL 6 Hardening Script (Master Script)
# License: GPL (see COPYING)
# Copyright: Red Hat Consulting, Sep 2013
# Author: Frank Caviggia <fcaviggi (at) redhat.com>

# Determine the Path
function realpath() {
    local r=$1; local t=$(readlink $r)
    while [ $t ]; do
        r=$(cd $(dirname $r) && cd $(dirname $t) && pwd -P)/$(basename $t)
        t=$(readlink $r)
    done
    echo $r
}

# ENVIRONMENT VARIABLES
DATE=`date +%F`
VERSION='1.1'
BASE_DIR=`dirname $(realpath $0)`
BACKUP=$BASE_DIR/backups
LOG=/var/log/system-hardening-$DATE.log
SKIPSCRIPTS=""
HITSCRIPTS=""

# Script Version
function version() {
	echo "Hardening Scripts for RHEL 6 (v.$VERSION)"
}

# USAGE STATEMENT
function usage() {
cat << EOF
usage: $0 [options]

  -v    Show version
  -h 	Show this message
  -q	Quiet output for scripting use
  -s	Skip designated script; argument can be repeated
  -S	Skip all scripts listed in designated file
  -I	Only include and run scripts listed in designated file

Hardening Scripts for RHEL 6 (v.$VERSION)

Applies Hardening Configurations to a system.

The scripts apply best-practice configurations based upon 
the following standards:

     DISA RHEL 6 STIG

     NIST 800-53 SCAP (USGCB)

     NSA SNAC Guide for Red Hat Enterprise Linux

     Aqueduct Project
     https://fedorahosted.org/aqueduct

     Tresys Certifiable Linux Integration Platform (CLIP)
     http://oss.tresys.com/projects/clip
EOF
}

function addskips() {
# addskips <filename>
	if [ ! -f $1 ]; then
		echo "Referenced skip file not found"
		exit 1
	fi
	for i in `cat $1 | grep -v "^#"`
	do
		SKIPSCRIPTS+=$i" "
	done
}

function addhits() {
# addhits <file name>
	if [ ! -f $1 ]; then
		echo "Referenced selection file not found"
		exit 1
	fi
	for i in `cat $1 | grep -v "^#"`
	do
		HITSCRIPTS+=$i" "
	done
}

function processdir() {
# processdir <dir name> 
	for i in `ls $1/*.sh`; do 
		echo $SKIPSCRIPTS | grep -q `echo $i | cut -f 2- -d /`
		if [ $? -ne 0 ]; then
			if [ -z "$QUIET" ]; then
				echo  "#### Executing Script: $i" | tee -a $LOG
				sh $i 2>&1 | tee -a $LOG
			else
				echo "#### Executing Script: $i" >> $LOG
				sh $i >> $LOG
			fi
		else 
			echo skipping $i per user request
		fi
	done;
}

while getopts ":vhqs:S:I:" OPTION; do
	case $OPTION in
		v)
			version
			exit 0
			;;
		h)
			usage
			exit 0
			;;
		q)
			QUIET=1
			;;
		s) 
			SKIPSCRIPTS+=$OPTARG" "
			;;
		S)
			addskips $OPTARG
			;;
		I)
			addhits $OPTARG
			;;
		?)
			echo "ERROR: Invalid Option Provided!"
			echo
			usage
			exit 1
			;;
	esac
done

if [ -z "$QUIET" ]; then
	echo -e "\033[3m\033[1mRed Hat Enterprise 6 Linux Hardening Scripts\033[0m\033[0m"
	echo
	echo "These scripts will harden a system to specifications that" 
	echo "are based upon the the following standards:"
	echo
	cat << EOF
     DISA RHEL 6 STIG

     NIST 800-53 SCAP (USGCB)

     NSA SNAC Guide for Red Hat Enterprise Linux

     Aqueduct Project
     https://fedorahosted.org/aqueduct

     Tresys Certifiable Linux Integration Platform (CLIP)
     http://oss.tresys.com/projects/clip
EOF
	echo
fi

# Check for root user
if [[ $EUID -ne 0 ]]; then
	if [ -z "$QUIET" ]; then
		echo
		tput setaf 1;echo -e "\033[1mPlease re-run this script as root!\033[0m";tput sgr0
	fi
	exit 1
fi

if [ -z "$QUIET" ]; then
	echo
	echo -e "\033[1mPlease snapshot or backup your system before running these scripts.\033[0m"
	echo
	echo -ne "\033[1mDo you want to continue?\033[0m [y/n]: "
	while read a; do
		case "$a" in
		y|Y)	break;;
		n|N)	exit 1;;
		*)	echo -n "[y/n]: ";;
		esac
	done
	echo
	echo -e "\033[1mStarting Configuration\033[0m"
fi

# CREATE LOG IF IT DOESN'T EXISIT
if [ ! -e $LOG ]; then
	touch $LOG
fi

echo "SCRIPT RUN: $(date)" >> $LOG
echo "Starting Configuration" >> $LOG

`rhn_check 2>/dev/null`
if [ $? -eq 0 ]; then
	echo '==================================================='
	echo ' Verifying RPM Requirements'
	echo '==================================================='
	yum -y install aide screen logwatch vlock openswan scrub
fi

# BACKUP ORIGINAL SYSTEM CONFIGURATIONS
if [ -z "$QUIET" ]; then
	echo -n "Back up current configuration... " | tee -a $LOG
else
	echo -n "Back up current configuration... " >> $LOG
fi

if [ ! -d $BACKUP ]; then
	mkdir -p $BACKUP
fi


# Miscellaneous backups that don't fit cleanly into other scripts
if [ ! -f "$BACKUP/issue.orig" ]; then
	cp /etc/issue $BACKUP/issue.orig
fi

if [ ! -f "$BACKUP/issue.net.orig" ]; then
	cp /etc/issue.net $BACKUP/issue.net.orig
fi

if [ ! -f "$BACKUP/ssh_config.orig" ]; then
	cp /etc/ssh/ssh_config $BACKUP/ssh_config.orig
fi

if [ ! -f "$BACKUP/profile.orig" ]; then
	cp /etc/profile $BACKUP/profile.orig
fi

if [ -z "$QUIET" ]; then
	echo "Done." | tee -a $LOG
else
	echo "Done." >> $LOG
fi


# CHANGE DIRECTORY TO BASE DIR
cd $BASE_DIR

if [ -z "$QUIET" ]; then
	echo "Done." | tee -a $LOG
else
	echo "Done." >> $LOG
fi


# SELECT SCRIPTS from "SECURITY ISSUES", "CUSTOM HARDENING", and "manual" - in that order
if [ -n "$HITSCRIPTS" ]; then
	echo >> $LOG
	for i in `ls config-scripts/*.sh scripts/*.sh` `ls misc/*.sh` `ls manual/*.sh`; do 
		echo $HITSCRIPTS | grep -q `echo $i | cut -f 2- -d /`
		if [ $? -eq 0 ]; then

			echo $SKIPSCRIPTS | grep -q `echo $i | cut -f 2- -d /`
			if [ $? -ne 0 ]; then
				if [ -z "$QUIET" ]; then
					echo  "#### Executing Script: $i" | tee -a $LOG
					sh $i 2>&1 | tee -a $LOG
				else
					echo "#### Executing Script: $i" >> $LOG
					sh $i >> $LOG
				fi
			else 
				echo skipping $i per user request
			fi
		fi
	done;
else
# SECURITY ISSUES
	echo >> $LOG

	# APPLYING DEFAULT SYSTEM CONFIGURATIONS
	if [ -z "$QUIET" ]; then
		echo -n "Applying base configuration files... " | tee -a $LOG
	else
		echo -n "Applying base configuration files... " >> $LOG
	fi
        processdir config-scripts
	processdir scripts

# CUSTOM HARDENING
	if [ -z "$QUIET" ]; then
		echo
		echo -e "\033[1mAdditional Hardening\033[0m"
		echo
	fi
	echo >> $LOG
	echo "Additional Hardening Scripts" >> $LOG
	echo >> $LOG
	processdir misc
fi

if [ -z "$QUIET" ]; then
	echo 2>&1 | tee -a $LOG;
	tput setaf 2;echo -e "\033[1mConfiguration Complete!\033[0m";tput sgr0
fi
echo >> $LOG
echo "Configuration Complete!" >> $LOG

exit 0
