#!/bin/bash

otp_mac=$(hexdump -x -v /sys/devices/platform/soc@0/30000000.bus/30350000.efuse/imx-ocotp0/nvmem | grep 0000090)

mac_valid=$(echo $otp_mac | cut -d" " -f 5)

if [ "$mac_valid" != "0000" ] && [ "$mac_valid" != "ffff" ]; then
	otp_mac1=$(echo $otp_mac | cut -d" " -f 7)
	otp_mac2=$(echo $otp_mac | cut -d" " -f 6)
	otp_mac3=$(echo $otp_mac | cut -d" " -f 5)
	otp_mac=$otp_mac1$otp_mac2$otp_mac3
	ifconfig eth0 hw ether $otp_mac
fi

exit
