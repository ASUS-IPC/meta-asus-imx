# Copyright (C) 2022 Asus
# Released under the MIT license (see COPYING.MIT for the terms)

SUMMARY = "imx-image-full with a couple additions by Asus"
LICENSE = "MIT"

IMAGE_FSTYPES = "${@bb.utils.contains_any('FOTA_ENABLED', 'ENABLED', 'wic.bz2 ext4 ext4.gz wic.bmap wic.gz', 'wic.bz2', d)}"

IMAGE_INSTALL:append:mx8mq-nxp-bsp = " \
	asus-overlay \
	gptfdisk \
	vim \
	networkmanager \
	networkmanager-nmcli \
	networkmanager-nmtui \
	networkmanager-wwan \
	networkmanager-ppp \
	bash-completion \
	whiptail \
	hdparm \
	ntfs-3g \
	docker \
	docker-ce \
	python3-docker-compose \
	glibc-gconv-utf-16 \
	phytool \
	psplash \
	can-utils-cantest \
	can-utils-access \
	iotedge \
	aziotd \
	aziot-edged \
	aziotctl \
"


IMAGE_INSTALL:append:mx8mp-nxp-bsp = " \
   	asus-overlay \
	gptfdisk \
	vim \
	networkmanager \
	networkmanager-nmcli \
	networkmanager-nmtui \
	phytool \
	psplash \
	can-utils-cantest \
	can-utils-access \
	docker \
	docker-ce \
	python3-docker-compose \
	glibc-gconv-utf-16 \
"

do_prepare_ramdisk() {
    if [ "${FOTA_ENABLED}" = "ENABLED" ]; then
        install -d ${IMAGE_ROOTFS}/recovery
        install -m 0755 ${DEPLOY_DIR_IMAGE}/Image ${IMAGE_ROOTFS}/recovery/Image
        install -m 0755 ${DEPLOY_DIR_IMAGE}/${UBOOT_DTB_NAME} ${IMAGE_ROOTFS}/recovery/swupdate-image.dtb
        install -m 0755 ${DEPLOY_DIR_IMAGE}/swupdate-image-${MACHINE}.cpio.gz.u-boot ${IMAGE_ROOTFS}/recovery/swupdate-image.img
    fi
}

addtask do_prepare_ramdisk before do_image after do_rootfs