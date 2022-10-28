# Copyright (C) 2022 Asus
# Released under the MIT license (see COPYING.MIT for the terms)

SUMMARY = "imx-image-full with a couple additions by Asus"
LICENSE = "MIT"

IMAGE_INSTALL_append += " \
	asus-overlay \
	gptfdisk \
	exfat-utils \
	fuse-exfat \
	ntfs-3g \
	gpsd \
	networkmanager \
	networkmanager-nmcli \
	networkmanager-nmtui \
	iotedge-daemon \
	iotedge-cli \
	docker \
	docker-ce \
	ca-certificates \
	canopensocket \
	can-utils-j1939 \
	vim \
	whiptail \
	glibc-utils \
	glibc-gconv-utf-16 \
	localedef \
	cmake \
	packagegroup-core-buildessential \
	ppp \
	libqmi \
	libmbim \
	edgetpu \
	mraa \
	modemmanager \
	opkg \
        python3-docker-compose \
"