#!/bin/bash

# set printk to 7 to dump kernel message to console
echo 7 > /proc/sys/kernel/printk

/sbin/hwclock -s

#/sbin/resize-data.sh

# Enable WOL function
/etc/network/ethernet_wol.sh
# Fix eth0 mac address
/etc/network/ethernet_mac.sh

# Default sound output device: HDMI
/etc/audio/switch_sound_device.sh

exit 0

