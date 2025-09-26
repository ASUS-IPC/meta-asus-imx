#!/bin/sh

timeout=$1

if [ -n "$timeout" ]; then
	sleep $timeout
fi

echo "o"> /proc/sysrq-trigger
