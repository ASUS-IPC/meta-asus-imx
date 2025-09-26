#!/bin/sh

# reboot / poweroff
mode=$1
timeout=$2

if [ -n "$timeout" ]; then
	/sbin/monitor_${mode}.sh $timeout &
else
	/sbin/monitor_${mode}.sh
fi
