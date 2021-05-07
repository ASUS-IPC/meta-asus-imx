#!/bin/sh
#
# Called from udev
#
# Attempt to mount any added block devices and umount any removed devices
ACTION=$1
DEVBASE=$2
DEVICE="/dev/${DEVBASE}"
DEVNAME=$DEVICE
MAJOR_HEX=`stat -c %t $DEVNAME`
MINOR_HEX=`stat -c %T $DEVNAME`
MAJOR=$((16#$MAJOR_HEX))
MINOR=$((16#$MINOR_HEX))

ID_FS_TYPE=$(lsblk -no FSTYPE $DEVNAME | head -n 1)

MOUNT="/bin/mount"
PMOUNT="/usr/bin/pmount"
UMOUNT="/bin/umount"

ROOTFS_MMCBLK=$(lsblk | grep "part /" | grep -v "/[a-z]" | awk -F ' ' '{print $1}' | awk -F '`-' '{print $2}' | awk -F 'p3' '{print $1}')
name="`basename "$DEVNAME"`"

for line in `grep -h -v ^# /etc/udev/mount.blacklist /etc/udev/mount.blacklist.d/*`
do
	if [ ` expr match "$DEVNAME" "$line" ` -gt 0 ];
	then
		logger "udev/mount_fs.sh" "[$DEVNAME] is blacklisted(c1), ignoring"
		exit 0
	fi
done

if [ `expr match "$name" "$ROOTFS_MMCBLK"` -gt 0 ];
then
	logger "udev/mount_fs.sh" "[$DEVNAME] is blacklisted(c2), ignoring"
	exit 0
fi

automount() {
	name="`basename "$DEVNAME"`"

	! test -d "/run/media/$name" && mkdir -p "/run/media/$name"
	# Silent util-linux's version of mounting auto
	if [ "x`readlink $MOUNT`" = "x/bin/mount.util-linux" ] ;
	then
		MOUNT="$MOUNT -o silent"
	fi

	# If filesystem type is vfat, change the ownership group to 'disk', and
	# grant it with  w/r/x permissions.
	case $ID_FS_TYPE in
	vfat|fat)
		MOUNT="$MOUNT -o umask=007,gid=`awk -F':' '/^disk/{print $3}' /etc/group`"
		;;
	# TODO
	*)
		;;
	esac

	if ! $MOUNT -t auto $DEVNAME "/run/media/$name"
	then
		#logger "mount_fs.sh/automount" "$MOUNT -t auto $DEVNAME \"/run/media/$name\" failed!"
		rm_dir "/run/media/$name"
	else
		logger "mount_fs.sh/automount" "Auto-mount of [/run/media/$name] successful"
		touch "/tmp/.automount-$name"
	fi
}

rm_dir() {
	# We do not want to rm -r populated directories
	if test "`find "$1" | wc -l | tr -d " "`" -lt 2 -a -d "$1"
	then
		! test -z "$1" && rm -r "$1"
	else
		logger "mount_fs.sh/automount" "Not removing non-empty directory [$1]"
	fi
}

# No ID_FS_TYPE for cdrom device, yet it should be mounted
name="`basename "$DEVNAME"`"
[ -e /sys/block/$name/device/media ] && media_type=`cat /sys/block/$name/device/media`

logger "====== mount_fs.sh [ACTION: $ACTION] [DEVNAME: $DEVNAME] [ID_FS_TYPE: $ID_FS_TYPE] [major:min = $MAJOR:$MINOR] ===="
if [ "$ACTION" = "add" ] && [ -n "$DEVNAME" ] && [ -n "$ID_FS_TYPE" -o "$media_type" = "cdrom" ]; then
	if [ -x "$PMOUNT" ]; then
		$PMOUNT $DEVNAME 2> /dev/null
	elif [ -x $MOUNT ]; then
    		$MOUNT $DEVNAME 2> /dev/null
	fi

	# If the device isn't mounted at this point, it isn't
	# configured in fstab (note the root filesystem can show up as
	# /dev/root in /proc/mounts, so check the device number too)
	if expr $MAJOR "*" 256 + $MINOR != `stat -c %d /`; then
		grep -q "^$DEVNAME " /proc/mounts || automount
	fi
fi


if [ "$ACTION" = "remove" ] || [ "$ACTION" = "change" ] && [ -x "$UMOUNT" ] && [ -n "$DEVNAME" ]; then
	for mnt in `cat /proc/mounts | grep "$DEVNAME" | cut -f 2 -d " " `
	do
		$UMOUNT $mnt
	done

	# Remove empty directories from auto-mounter
	name="`basename "$DEVNAME"`"
	test -e "/tmp/.automount-$name" && rm_dir "/run/media/$name"
fi
