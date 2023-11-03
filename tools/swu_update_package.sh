#!/bin/bash
CMD=`realpath $0`
TOOLS_DIR=`dirname $CMD`
TOP_DIR=$(realpath $TOOLS_DIR/../../..)

BUILD_DIR=build_${TARGET_PRODUCT}_${VERSION}
EXT4_FILE=$IMAGE_TYPE-$TARGET_PRODUCT.ext4

#copy related file
WORK_DIR=$TOP_DIR/update_package_build
mkdir -p $WORK_DIR
cp $TOP_DIR/$BUILD_DIR/tmp/deploy/images/$TARGET_PRODUCT/Image $WORK_DIR
cp $TOP_DIR/$BUILD_DIR/tmp/deploy/images/$TARGET_PRODUCT/$TARGET_PRODUCT.dtb $WORK_DIR
cp $TOP_DIR/$BUILD_DIR/tmp/deploy/images/$TARGET_PRODUCT/$EXT4_FILE $WORK_DIR
cp $TOP_DIR/$BUILD_DIR/tmp/deploy/images/$TARGET_PRODUCT/imx-boot-$TARGET_PRODUCT-*.bin-flash_evk $WORK_DIR
cp $TOP_DIR/sources/meta-asus-imx/tools/update_package_tool/* $WORK_DIR

FILE=$WORK_DIR/boot_pt_85196K.mirror
if [ ! -f "$FILE" ]; then
	#create boot partition mirror file
	truncate -s 85196K $WORK_DIR/boot_pt_85196K.mirror
fi

#boot partition
#formate boot partiotion to vfat, then put dtb and kernel into it, make it to .gz
mkfs.vfat $WORK_DIR/boot_pt_85196K.mirror
mcopy -i $WORK_DIR/boot_pt_85196K.mirror $WORK_DIR/$TARGET_PRODUCT.dtb ::$TARGET_PRODUCT.dtb
mcopy -i $WORK_DIR/boot_pt_85196K.mirror $WORK_DIR/Image ::Image

FILE=$WORK_DIR/boot_pt_85196K.mirror.gz
if [ -f "$FILE" ]; then
	#remove .gz if exist
	rm $FILE
fi
gzip -9k $WORK_DIR/boot_pt_85196K.mirror

#rootfs
#adjust rootfs to 7G, make it to .gz
truncate -s 6500M $WORK_DIR/$EXT4_FILE
e2fsck -f $WORK_DIR/$EXT4_FILE
resize2fs $WORK_DIR/$EXT4_FILE

FILE=$WORK_DIR/$EXT4_FILE.gz
if [ -f "$FILE" ]; then
	#remove .gz if exist
	rm $FILE
fi
gzip -9k $WORK_DIR/$EXT4_FILE

#get sha256 then update sw-description
IFS=' '

temp=`sha256sum $WORK_DIR/boot_pt_85196K.mirror.gz`
read -ra ADDR <<< "$temp"
sed -i ':a;N;$!ba; s/sha256/sha256 = "'"${ADDR[0]}"'"/1' $WORK_DIR/sw-description

temp=`sha256sum $WORK_DIR/$EXT4_FILE.gz`
read -ra ADDR <<< "$temp"
sed -i ':a;N;$!ba; s/sha256/sha256 = "'"${ADDR[0]}"'"/2' $WORK_DIR/sw-description

temp=`sha256sum $WORK_DIR/imx-boot-$TARGET_PRODUCT-*.bin-flash_evk`
read -ra ADDR <<< "$temp"
sed -i ':a;N;$!ba; s/sha256/sha256 = "'"${ADDR[0]}"'"/3' $WORK_DIR/sw-description

temp=`sha256sum $WORK_DIR/emmc_bootpart.sh`
read -ra ADDR <<< "$temp"
sed -i ':a;N;$!ba; s/sha256/sha256 = "'"${ADDR[0]}"'"/4' $WORK_DIR/sw-description

unset IFS

BOOT_FILE=`ls $WORK_DIR | grep imx-boot-$TARGET_PRODUCT`
EXT4_FILE=$EXT4_FILE.gz
#create .swu
cd $WORK_DIR
BOOT_FILE=$BOOT_FILE EXT4_FILE=$EXT4_FILE $WORK_DIR/swu_signed_image_build.sh

echo "build swu_update_package done"
