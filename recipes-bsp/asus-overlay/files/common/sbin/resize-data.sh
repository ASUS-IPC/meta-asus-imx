#!/bin/sh

# we must be root
[ $(whoami) = "root" ] || { echo "E: You must be root" && exit 1; }

# we must have few tools
SGDISK=$(which sgdisk) || { echo "E: You must have sgdisk" && exit 1; }
PARTED=$(which parted) || { echo "E: You must have parted" && exit 1; }
PARTPROBE=$(which partprobe) || { echo "E: You must have partprobe" && exit 1; }
RESIZE2FS=$(which resize2fs) || { echo "E: You must have resize2fs" && exit 1; }

echo "resize: start resize-date.sh" > /dev/kmsg

#find block device
BLOCK_DEVICE_NUMBER=1
BLOCK_DEVICE=$(mount | grep " \/ " | cut -c 1-12)

echo "resize: BLOCK_DEVICE=$BLOCK_DEVICE"  > /dev/kmsg

if [ "$BLOCK_DEVICE" = "/dev/mmcblk1" ]
   then
      BLOCK_DEVICE_NUMBER=1
   else
     BLOCK_DEVICE_NUMBER=0
fi
echo "resize: BLOCK_DEVICE_NUMBER=$BLOCK_DEVICE_NUMBER"  > /dev/kmsg

# find data device
PART_ENTRY_NUMBER=$(ls /sys/class/block/mmcblk$BLOCK_DEVICE_NUMBER | grep -c mmcblk"$BLOCK_DEVICE_NUMBER"p)
echo "resize: /sys/class/block/mmcblk$BLOCK_DEVICE_NUMBER "  > /dev/kmsg
echo "resize: PART_ENTRY_NUMBER=$PART_ENTRY_NUMBER"  > /dev/kmsg
if [ "$PART_ENTRY_NUMBER" -le "3" ]; then
     echo "there is no data partition" > /dev/kmsg
     exit 1
fi

DATA_DEVICE="/dev/mmcblk"$BLOCK_DEVICE_NUMBER"p$PART_ENTRY_NUMBER"
echo "resize: DATA_DEVICE=$DATA_DEVICE" > /dev/kmsg

PARTITION_SIZE=$(cat /sys/class/block/mmcblk$BLOCK_DEVICE_NUMBER/mmcblk"$BLOCK_DEVICE_NUMBER"p$PART_ENTRY_NUMBER/size)
echo "resize:PARTITION_SIZE=$PARTITION_SIZE" > /dev/kmsg

if [ "$PARTITION_SIZE" -le "1048576" ]; then
      echo "resize: need resize, PARTITION_SIZE=$PARTITION_SIZE" > /dev/kmsg
else
      echo "resize: already resize,exit" > /dev/kmsg
      exit 1
fi

# prune data device (for example UUID)
DATA_DEVICE=$(realpath ${DATA_DEVICE})

# get the partition number and type
PART_TABLE_TYPE=$(udevadm info --query=property --name=${DATA_DEVICE} | grep '^ID_PART_TABLE_TYPE=' | cut -d'=' -f2)
# find the block device
DEVICE=$(udevadm info --query=path --name=${DATA_DEVICE} | awk -F'/' '{print $(NF-1)}')
DEVICE="/dev/${DEVICE}"


echo "resize: DEVICE=$DEVICE" > /dev/kmsg
if [ "$PART_TABLE_TYPE" = "gpt" ]; then
	${SGDISK} -e ${DEVICE}
	${PARTPROBE}
fi
echo "resize:strat resize" > /dev/kmsg
umount ${DATA_DEVICE}
umount ${DATA_DEVICE}
umount ${DATA_DEVICE}

${PARTED} ${DEVICE} resizepart ${PART_ENTRY_NUMBER} 100%

mount /dev/mmcblk"$BLOCK_DEVICE_NUMBER"p$PART_ENTRY_NUMBER /data

${PARTPROBE}
${RESIZE2FS} "${DATA_DEVICE}"
echo "resize: resize-date.sh end" > /dev/kmsg

if [ ! -d "/data/already_resize" ]; then
    mkdir /data/already_resize
    reboot
fi


