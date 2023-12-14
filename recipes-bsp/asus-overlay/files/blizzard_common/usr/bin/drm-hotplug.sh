#!/bin/sh


hdmi_status=$(cat /sys/class/drm/card1-HDMI-A-1/status)

# Config audio output devices when HDMI hot-plug
if [ $hdmi_status = "connected" ];
then
	echo "Plug-in HDMI, set default sound card to HDMI"
	/etc/pulse/switch_sound_device.sh "alsa_output.platform-sound-hdmi.stereo-fallback"
else
	echo "Plug-out HDMI, set default sound card to WM8904"
	/etc/pulse/switch_sound_device.sh "alsa_output.platform-sound-wm8904.stereo-fallback"
fi

exit 0
