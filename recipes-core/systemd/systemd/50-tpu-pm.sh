#!/bin/sh

case "$1" in
	pre)
		all_tpu=`lspci -n | grep "1ac1:089a" | awk '{print $1}'`
		if [ $all_tpu ]; then
			for tpu in $all_tpu
			do
				logger -t TPU "remove TPU device ($tpu)"
				echo 1 > /sys/bus/pci/devices/$tpu/remove
			done
		else
			logger -t TPU "no TPU found"
		fi
		;;
	post)
		logger -t TPU "after resume"
		echo 1 > /sys/bus/pci/rescan
		;;
esac
