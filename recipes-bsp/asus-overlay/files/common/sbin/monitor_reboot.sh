#!/bin/sh

timeout=$1

if [ -n "$timeout" ]; then
	sleep $timeout
fi

echo "b"> /proc/sysrq-trigger
