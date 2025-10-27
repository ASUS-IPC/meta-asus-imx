#!/bin/sh
#
# Usage:
# usbdevice [start|update|stop]
#

[ -z "$DEBUG" ] || set -x

# Load default env variables from profiles
. /etc/profile

# Enable error out after loading env
set -e

TAG_DIR=/var/run/
LOG_FILE=/var/log/usbdevice.log
USB_FUNCS_FILE=/var/run/.usbdevice

usb_enable()
{
	touch $USB_FUNCS_FILE
}

usb_disable()
{
	rm -f $USB_FUNCS_FILE
}

usb_is_enabled()
{
	[ -f $USB_FUNCS_FILE ]
}

usb_set_started()
{
	echo $USB_FUNCS > $USB_FUNCS_FILE
}

usb_get_started()
{
	usb_is_enabled || return 0
	cat $USB_FUNCS_FILE
}

CONFIGFS_DIR=/sys/kernel/config
USB_GROUP=asus
USB_STRINGS_ATTR=strings/0x409
USB_GADGET_DIR=$CONFIGFS_DIR/usb_gadget/$USB_GROUP
USB_GADGET_STRINGS_DIR=$USB_GADGET_DIR/$USB_STRINGS_ATTR
USB_FUNCTIONS_DIR=$USB_GADGET_DIR/functions
USB_CONFIGS_DIR=$USB_GADGET_DIR/configs/b.1
USB_CONFIGS_STRINGS_DIR=$USB_CONFIGS_DIR/$USB_STRINGS_ATTR

# Make sure that we own this session (pid equals sid)
if [ $(sed "s/(.*)//" /proc/$$/stat | cut -d' ' -f6) != $$ ]; then
	setsid $0 $@
	exit $?
fi

# ---- helper functions
usb_msg()
{
	logger -t "$(basename "$0")" "[$$]: $@"
	echo "[$(date +"%F %T")] $@"
}

# Based on <<Rockchip_Developer_Guide_USB_CN>> V2.0.0
usb_pid()
{
	case "$(echo $USB_FUNCS | xargs -n 1 | sort | xargs | tr ' ' '-')" in
		ums)			echo 0x7820;;
		rndis)			echo 0x7774;;
		adb)			echo 0x7770;; # Single ADB
		adb-rndis)		echo 0x7775;; # For Android
		*)			echo 0x00ff;; # Undefined
	esac
}

usb_vid()
{
	case "$(echo $USB_FUNCS | xargs -n 1 | sort | xargs | tr ' ' '-')" in
		ums)		echo 0x0b05;;
		adb)		echo 0x0b05;;
		rndis)		echo 0x0b05;;
		adb-rndis)	echo 0x0b05;;
		*)		echo 0x2207;;
	esac
}

usb_instances()
{
	for func in $@; do
		VAR=$(echo $func | tr 'a-z' 'A-Z')_INSTANCES
		eval echo "\${$VAR:-$func.0}"
	done
}

usb_run_stage()
{
	for f in $1_pre_$2_hook $1_$2 $1_post_$2_hook; do
		type $f >/dev/null 2>/dev/null || continue

		usb_msg "Run stage: $f"
		eval $f || break
	done
}

usb_wait_files()
{
	for i in `seq 200`;do
		fuser -s $@ 2>/dev/null && break
		sleep .01
	done
}

usb_release_files()
{
	for i in `seq 200`;do
		fuser -s -k $@ 2>/dev/null || break
		sleep .01
	done
}

# usage: usb_mount <src> <mountpoint> <options>
usb_mount()
{
	mkdir -p $2
	mountpoint -q $2 || mount $@
}

usb_umount()
{
	mountpoint -q $1 || return 0
	usb_release_files -m $1
	umount $1
}

usb_symlink()
{
	mkdir -p $1
	mkdir -p $(dirname $2)
	[ -e $2 ] || ln -s $1 $2
}

usb_write()
{
	if echo "x$1" | grep -q "^x-"; then
		OPTS="$1"
		shift
	fi

	FILE="$1"
	shift

	if [ ! -w "$FILE" ]; then
		echo "$FILE not writable!"
		return 1
	fi

	if [ -r "$FILE" ] && [ "$(cat "$FILE")" = "$*" ]; then
		return 0
	fi

	echo $OPTS $@ > "$FILE"
}

usb_start_daemon()
{
	NAME=$(echo $1 | sed "s~^[^ ]*/\([^ ]*\).*~\1~")
	TAG_FILE=$TAG_DIR.usb_$NAME

	# Enable spawn
	touch $TAG_FILE

	# Already started
	[ -z "$(usb_get_started)" ] || return 0

	# Start and spawn background daemon
	{
		exec 3<&-

		cd /; cd /
		while usb_is_enabled; do
			# Don't spawn after stopped
			[ ! -f $TAG_FILE ] ||
				/sbin/start-stop-daemon -Sqx $@ || true
			sleep .5
		done
	}&
}

usb_stop_daemon()
{
	NAME=$(echo $1 | sed "s~^[^ ]*/\([^ ]*\).*~\1~")
	TAG_FILE=$TAG_DIR.usb_$NAME

	# Stop and disable spawn
	rm -f $TAG_FILE
	/sbin/start-stop-daemon -Kqox $@
}

usb_load_config()
{
	USB_CONFIG_FILE=$(find /tmp/ /etc/ -name .usb_config | head -n 1)
	[ -n "$USB_CONFIG_FILE" -a -r "$USB_CONFIG_FILE" ] || return 0

	echo "Loading configs from $USB_CONFIG_FILE ..."

	ums_parse()
	{
		grep "\<$1=" "$USB_CONFIG_FILE" | cut -d'=' -f2
	}
	UMS_FILE="$(ums_parse ums_block)"
	UMS_SIZE=$(ums_parse ums_block_size || echo 0)M
	UMS_FSTYPE=$(ums_parse ums_block_type)
	UMS_MOUNT=$([ "$(ums_parse ums_block_auto_mount)" != on ] || echo 1)
	UMS_RO=$([ "$(ums_parse ums_block_ro)" != on ] || echo 1)

	USB_FUNCS="$(sed -n "s/usb_\(.*\)_en/\1/p" "$USB_CONFIG_FILE" | xargs)"
}

# ---- adb
ADB_INSTANCES=${ADB_INSTANCES:-ffs.adb}

adb_prepare()
{
	usb_mount adb /dev/usb-ffs/adb -o uid=2000,gid=2000 -t functionfs
	usb_start_daemon /usr/bin/adbd
	usb_wait_files -m /dev/usb-ffs/adb
}

adb_stop()
{
	usb_stop_daemon /usr/bin/adbd
}

# ---- ums
UMS_INSTANCES=${UMS_INSTANCES:-mass_storage.0}

ums_prepare()
{
	if ! stat "$UMS_FILE" >/dev/null 2>/dev/null; then
		usb_msg "Formating $UMS_FILE($UMS_SIZE) to $UMS_FSTYPE"
		truncate -s $UMS_SIZE "$UMS_FILE"
		mkfs.$UMS_FSTYPE "$UMS_FILE" || \
			usb_msg "Failed to format $UMS_FILE to $UMS_FSTYPE"
	fi
}

ums_to_pc()
{
	if [ "$(cat lun.0/ro)" != "$UMS_RO" ]; then
		echo > lun.0/file
		echo $UMS_RO > lun.0/ro
	fi

	if ! grep -wq "$UMS_FILE" lun.0/file; then
		usb_umount "$UMS_MOUNTPOINT"
		echo "$UMS_FILE" > lun.0/file
	fi
}

ums_to_device()
{
	echo > lun.0/file

	[ "$UMS_MOUNT" -eq 1 ] || return 0

	usb_umount "$UMS_MOUNTPOINT"

	# Try auto fstype firstly
	usb_mount "$UMS_FILE" "$UMS_MOUNTPOINT" -o sync 2>/dev/null || \
		usb_mount "$UMS_FILE" "$UMS_MOUNTPOINT" -o sync -t $UMS_FSTYPE
}

ums_start()
{
	case "$USB_STATE" in
		CONFIGURED) ums_to_pc ;;
		DISCONNECTED) ums_to_device ;;
	esac
}

ums_stop()
{
	echo > lun.0/file

	if [ "$UMS_MOUNT" ]; then
		usb_umount "$UMS_MOUNTPOINT"
	fi
}

# ---- global
usb_init()
{
	usb_msg "Initializing"

	cd $USB_GADGET_DIR

	printf "0x%x" ${USB_VENDOR_ID:-0x2207} > idVendor
	printf "0x%x" ${USB_FW_VERSION:-0x0310} > bcdDevice

	mkdir -p $USB_GADGET_STRINGS_DIR
	SERIAL=`cat /sys/devices/soc0/serial_number`
	echo ${SERIAL:-0123456789ABCDEF} > $USB_GADGET_STRINGS_DIR/serialnumber
	echo $USB_GROUP  > $USB_GADGET_STRINGS_DIR/manufacturer
	if [ -e "/proc/boardinfo" ] ;
	then
		cat /proc/boardinfo  > $USB_GADGET_STRINGS_DIR/product
	else
		echo "PE100A"  > $USB_GADGET_STRINGS_DIR/product
	fi

	mkdir -p $USB_CONFIGS_DIR
	echo 500 > $USB_CONFIGS_DIR/MaxPower

	echo 0x1 > os_desc/b_vendor_code
	echo MSFT100 > os_desc/qw_sign
	ln -s $USB_CONFIGS_DIR os_desc/

	mkdir -p $USB_CONFIGS_STRINGS_DIR
}

usb_funcs_grep()
{
	echo $USB_FUNCS | xargs -n 1 | sort | uniq | grep $@ || true
}

usb_funcs_sort()
{
	{
		for func in $@; do
			usb_funcs_grep -E $func
		done
		usb_funcs_grep -vE $(echo $@ | tr ' ' '|')
	} | uniq | xargs
}

usb_prepare()
{
	usb_load_config

	UMS_FILE=${UMS_FILE:-/userdata/ums_shared.img}
	UMS_SIZE=${UMS_SIZE:-256M}
	UMS_FSTYPE=${UMS_FSTYPE:-vfat}
	UMS_MOUNT=${UMS_MOUNT:-0}
	UMS_MOUNTPOINT="${UMS_MOUNTPOINT:-/mnt/ums}"
	UMS_RO=${UMS_RO:-0}
	USB_FUNCS=${USB_FUNCS:-adb}
	USB_FUNCS="$(echo "$USB_FUNCS" | tr ',' ' ')"

	# Orders required by kernel
	USB_FUNCS="$(usb_funcs_sort rndis uac uvc adb ntb ums mtp acm)"
	USB_CONFIG="$(echo "$USB_FUNCS" | tr ' ' '_')"

	if [ ! -d $USB_GADGET_DIR ]; then
		mountpoint -q $CONFIGFS_DIR || \
			mount -t configfs none $CONFIGFS_DIR

		mkdir -p $USB_GADGET_DIR
		cd $USB_GADGET_DIR

		# Global initialize
		usb_run_stage usb init
	fi

	USB_STATE=$(cat /sys/class/android_usb/android*/state 2>/dev/null)
	usb_msg "USB state: ${USB_STATE:-unknown}"

	USB_UDC=$(ls /sys/class/udc/ | head -n 1)
	if [ -z "$USB_UDC" ]; then
		usb_msg "Failed to find a valid UDC device..."
		return 1
	fi

	usb_msg "Using USB UDC device: $USB_UDC"

	# Parse started USB functions
	OLD_FUNCS=$(usb_get_started)

	# Stop old USB functions when USB functions changed
	if [ -n "$OLD_FUNCS" ] && [ "$OLD_FUNCS" != "$USB_FUNCS" ]; then
		usb_msg "Functions changed $OLD_FUNCS -> $USB_FUNCS"
		usb_stop
	fi

	# Update USB VID
	usb_vid > $USB_GADGET_DIR/idVendor
	# Update USB PID
	usb_pid > $USB_GADGET_DIR/idProduct
}

usb_start()
{
	usb_msg "Starting functions: $USB_FUNCS"

	echo "$USB_CONFIG" > $USB_CONFIGS_STRINGS_DIR/configuration

	for func in $USB_FUNCS; do
		for instance in $(usb_instances $func); do
			usb_msg "Preparing instance: $instance"

			if ! mkdir -p $USB_FUNCTIONS_DIR/$instance \
				2>/dev/null; then
				usb_msg "Failed to create instance: $instance"
				continue
			fi

			cd $USB_FUNCTIONS_DIR/$instance \
				>/dev/null 2>/dev/null || continue

			usb_run_stage $func prepare

			# Make symlink after prepared (required by UVC)
			usb_symlink $USB_FUNCTIONS_DIR/$instance \
				$USB_CONFIGS_DIR/f-$instance
		done
	done

	usb_write $USB_GADGET_DIR/UDC $USB_UDC

	for func in $USB_FUNCS; do
		for instance in $(usb_instances $func); do
			cd $USB_FUNCTIONS_DIR/$instance \
				>/dev/null 2>/dev/null || continue

			usb_msg "Starting instance: $instance"
			usb_run_stage $func start
		done
	done

	# Store started functions
	usb_set_started
}

usb_stop()
{
	if [ -n "$OLD_FUNCS" ]; then
		usb_msg "Stopping functions: $OLD_FUNCS"
	fi

	usb_write $USB_GADGET_DIR/UDC ""

	for func in $USB_FUNCS; do
		for instance in $(usb_instances $func); do
			cd $USB_FUNCTIONS_DIR/$instance \
				>/dev/null 2>/dev/null || continue

			usb_msg "Stopping instance: $instance"
			usb_run_stage $func stop
		done
	done

	rm -f $USB_CONFIGS_DIR/f-*

	# Keep ffs instances registered and mounted, to avoid random crashes
	find $USB_FUNCTIONS_DIR -mindepth 1 -maxdepth 1 ! -name 'ffs.*' | \
		xargs rmdir 2>/dev/null || true

	# Clear functions to avoid stopping them again
	unset OLD_FUNCS
}

usb_restart()
{
	usb_run_stage usb stop
	usb_run_stage usb start
}

ACTION=${1:-update}
if [ "$ACTION" = update ]; then
	usb_is_enabled || exit 0
fi

# Lock it
exec 3<$0
flock -x 3

if [ -z "$DEBUG" ]; then
	echo "Starting $0 ${ACTION}, log saved to $LOG_FILE"

	# Redirect outputs to log file
	exec >>$LOG_FILE 2>&1
fi

usb_msg "Handling ${ACTION} request"

if ! usb_run_stage usb prepare; then
	usb_run_stage usb stop
	exit 1
fi

case "$ACTION" in
	start|update)
		usb_enable
		usb_run_stage usb start
		;;
	stop)
		usb_disable
		usb_run_stage usb stop
		;;
	restart)
		usb_enable
		usb_run_stage usb restart
		;;
	*)
		echo "Usage: usbdevice [start|stop|restart|update]" >&2
		;;
esac

usb_msg "Done $ACTION request"
echo

# Unlock it
flock -u 3
