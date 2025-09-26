#!/bin/bash

check_wifi_module()
{
	retval="none"
	result=`lsusb | awk '{print $6}' | grep "13d3:3519"`
	if [ -n "$result" ]; then
		retval="aw-cb260nf"
	fi
	result=`lsusb | awk '{print $6}' | grep "0cf3:e300"`
	if [ -n "$result" ]; then
		retval="jww6051"
	fi
	echo $retval
}

wifi_module=$(check_wifi_module)
logger -t wifi_init "wifi_module=$wifi_module"
if [ $wifi_module == "none" ]; then
	logger -t wifi_init "no wifi module detectd"
	exit 0
fi

bdwlan30_1="/lib/firmware/qca6174/bdwlan30.bin"
bdwlan30_2="/lib/firmware/qca6174/bdwlan30.bin_$wifi_module"

if cmp -s "$bdwlan30_1" "$bdwlan30_2"
then
	logger -t wifi_init "no difference"
else
	logger -t wifi_init "wifi module was changed, change bdwlan30.bin"
	ln -sf $bdwlan30_2 $bdwlan30_1
	sleep 1
	logger -t wifi_init "remove wifi module"
	modprobe -r qca6174
	sleep 1
	logger -t wifi_init "insert wifi module"
	modprobe qca6174
fi
