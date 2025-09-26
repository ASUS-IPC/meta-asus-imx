#!/bin/bash

# set printk to 7 to dump kernel message to console
echo 7 > /proc/sys/kernel/printk

/sbin/hwclock -s

# Enable WOL for LAN1
/usr/sbin/ethtool -s eth0 wol g
#/sbin/resize-data.sh

# Fix eth0 mac address
/etc/network/ethernet_mac.sh

exit 0

