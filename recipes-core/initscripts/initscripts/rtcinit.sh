#!/bin/sh

# Source function library.
. /etc/init.d/functions

start_rtc_init(){
	ret=$(hwclock -r)
	if [ "$ret" == "" ] ; then
		hwclock -w
	fi
}


case "$1" in
  start)
	start_rtc_init;;
  *)
	echo "Usage: $0 {start|stop}"
	exit 1
	;;
esac

