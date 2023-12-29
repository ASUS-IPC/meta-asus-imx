#!/bin/sh

hdmi_status="/sys/class/drm/card1-HDMI-A-1/status"

# turn off then turn on HDMI
if [ "$(cat $hdmi_status)" = "connected" ];
then
	echo "replug_hdmi.sh turn HDMI off"
	echo "off" > $hdmi_status
	sleep 0.5
	echo "replug_hdmi.sh turn HDMI on"
	echo "on" > $hdmi_status
fi

exit 0
