#!/bin/bash -
# The K5DRU Config Script for new installations

# common functions, mostly do_step

die() 
{ 
	echo "$*" 1>&2
	exit 1 
}

## source the config
#CONFIG="$(dirname $0)/../common/config.sh"
#if [ ! -e $CONFIG ]; then 
#	die "Can't find config.sh in $CONFIG"
#fi
#. "$CONFIG"

LOGFILE="$(dirname $0)/$(basename $0).log"
echo LOGFILE is "$LOGFILE"

if [ $(whoami) != "root" ]; then 
	echo "This is system configuration; it really needs to be run as root."
	echo "Always check a script before running it as root, but it should be safe. " 
	die "plz run $0 as root"
fi

touch $LOGFILE || die "Can't write to log file $LOGFILE"

do_step() 
{ 
	# Do a thing. Record that it has been done. 
	# Don't do it if it has already been done. 
	# If it fails, ask to continue or abort. 

	# OPTIONS: --again will do it a second time. 
	#          --logfirst will log it, then do it.  Useful for rebooting. 	
	#          --pretend will not do it, then log it. 

	unset LOGFIRST 
	unset AGAIN
	unset PRETEND

## FIXME: allow in any order. 

	if [ "$1" == '--logfirst' ]; then 
		LOGFIRST=Y
		shift 
	fi
	
	if [ "$1" == '--pretend' ]; then 
		PRETEND=Y
		shift 
	fi
	
	if [ "$1" == '--again' ]; then 
		shift 
		AGAIN=$1
		shift
	fi

	# get a signature for this step
	FIRSTLINE="$(echo "$*" | head -1 | cut -b 1-80)"
	SIG="$(echo "$*$AGAIN" | md5sum | cut -f 1 -d ' ')"

	# check the logfile 
	grep "|$SIG|" $LOGFILE > /dev/null
	if [ $? = 0 ]; then 
		echo "already done: $FIRSTLINE" 
		return
	fi

	if [ "${LOGFIRST}" = 'Y' ]; then 
		echo "$(date '+%Y%m%d-%H%M%S')|$SIG|$FIRSTLINE|logged first" |
		tee -a $LOGFILE
	fi

	echo "### STARTING STEP:  $FIRSTLINE"
	sleep ${DELAY}

	if [ -z "$PRETEND" -a "$GLOBAL_PRETEND" != 'Y' ]; then 
"$@"
	else
		echo "pretending"
	fi 

	if [ $? = 0 ]; then 
		echo "$(date '+%Y%m%d-%H%M%S')|$SIG|$FIRSTLINE|" |
		tee -a $LOGFILE
		return
	fi
	# some failure happened 
	echo "FAIL: $FIRSTLINE" 
	echo "Enter to continue or control-c to quit and fix, 'a' to accept and move on with life. "
	read  y
	if [ "$y" = 'a' ]; then 
		echo "$(date '+%Y%m%d-%H%M%S')|$SIG|$FIRSTLINE|accepted failure" |
		tee -a $LOGFILE
	fi
}

