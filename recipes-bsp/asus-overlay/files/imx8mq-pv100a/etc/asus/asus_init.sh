#!/bin/bash

# set printk to 7 to dump kernel message to console
echo 7 > /proc/sys/kernel/printk

echo "13" > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio13/direction
echo "0" > /sys/class/gpio/gpio13/value
echo "13" > /sys/class/gpio/unexport

/sbin/hwclock_mcu -s

#g-sensor: set the value of the register 0x19 to 0x02 for mapping high-g to INT1 pin.
/usr/sbin/i2ctransfer -y 3 w9@0x10 0x02 0x07 0x06 0x52 0x00 0x30 0x00 0x19 0x02

# gps-led-g init
echo "1" > /sys/class/leds/ttymxc3-rxtx-g/brightness

# Enable WOL function
/etc/network/ethernet_wol.sh
#/sbin/resize-data.sh

# Default sound output device: HDMI
/etc/audio/switch_sound_device.sh

exit 0

