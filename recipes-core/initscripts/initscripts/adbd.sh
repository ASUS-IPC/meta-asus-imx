#!/bin/sh
### BEGIN INIT INFO
# Provides:          adbd
# Required-Start:
# Required-Stop:
# Default-Start: S
# Default-Stop: 6
# Short-Description:
# Description:       Linux ADB
### END INIT INFO

# setup configfs for adbd

ADB_EN=off

USB_ATTRIBUTE=0x409
USB_GROUP=asus
USB_SKELETON=b.1

CONFIGFS_DIR=/sys/kernel/config
USB_CONFIGFS_DIR=${CONFIGFS_DIR}/usb_gadget/${USB_GROUP}
USB_STRINGS_DIR=${USB_CONFIGFS_DIR}/strings/${USB_ATTRIBUTE}
USB_FUNCTIONS_DIR=${USB_CONFIGFS_DIR}/functions
USB_CONFIGS_DIR=${USB_CONFIGFS_DIR}/configs/${USB_SKELETON}

configfs_init()
{
	mkdir -p ${USB_CONFIGFS_DIR} -m 0770
	echo $VID > ${USB_CONFIGFS_DIR}/idVendor
	echo $PID > ${USB_CONFIGFS_DIR}/idProduct
	mkdir -p ${USB_STRINGS_DIR}   -m 0770

	SERIAL=`cat /sys/devices/soc0/soc_uid`
	if [ -z $SERIAL ];then
		SERIAL=0123456789ABCDEF
	fi
	echo $SERIAL > ${USB_STRINGS_DIR}/serialnumber
	echo "ASUS"  > ${USB_STRINGS_DIR}/manufacturer
	if [ -e "/proc/boardinfo" ] ;
	then
		cat /proc/boardinfo  > ${USB_STRINGS_DIR}/product
	else
		echo "Single Board Computer" > ${USB_STRINGS_DIR}/product
	fi
	mkdir -p ${USB_CONFIGS_DIR}  -m 0770
	mkdir -p ${USB_CONFIGS_DIR}/strings/${USB_ATTRIBUTE}  -m 0770
	echo 500 > ${USB_CONFIGS_DIR}/MaxPower
	echo ${CONFIG_STRING} > ${USB_CONFIGS_DIR}/strings/${USB_ATTRIBUTE}/configuration

}

function_init()
{
	if [ $ADB_EN = on ];then
		if [ ! -e "${USB_FUNCTIONS_DIR}/ffs.adb" ] ;
		then
			mkdir -p ${USB_FUNCTIONS_DIR}/ffs.adb
			ln -s ${USB_FUNCTIONS_DIR}/ffs.adb ${USB_CONFIGS_DIR}/ffs.adb
		fi
	fi
}

case "$1" in
start)
	ADB_EN=on
	CONFIG_STRING=adb
	VID=0x0b05
	PID=0x7770
	if [ -z $CONFIG_STRING ]; then
		echo "$0: no function be selected"
		exit 0
	fi
	configfs_init
	function_init

	if [ $ADB_EN = on ];then
		if [ ! -e "/dev/usb-ffs/adb" ] ;
		then
			mkdir -p /dev/usb-ffs/adb
			mount -o uid=2000,gid=2000 -t functionfs adb /dev/usb-ffs/adb
		fi
		export service_adb_tcp_port=5555
		start-stop-daemon --start --oknodo --pidfile /var/run/adbd.pid --startas /usr/bin/adbd --background
		sleep 1
	fi

	UDC=`ls /sys/class/udc/| awk '{print $1}'`
	 echo $UDC > ${USB_CONFIGFS_DIR}/UDC
	;;
stop)
	echo "none" > ${USB_CONFIGFS_DIR}/UDC
	if [ $ADB_EN = on ];then
		start-stop-daemon --stop --oknodo --pidfile /var/run/adbd.pid --retry 5
	fi
	;;
restart|reload)
	;;
*)
	echo "Usage: $0 {start|stop|restart}"
	exit 1
esac

exit 0
