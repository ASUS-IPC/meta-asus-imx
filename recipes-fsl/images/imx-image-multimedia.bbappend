# Copyright (C) 2022 Asus
# Released under the MIT license (see COPYING.MIT for the terms)

SUMMARY = "imx-image-multimedia with a couple additions by Asus"
LICENSE = "MIT"

IMAGE_INSTALL += " \
	can-utils \
	networkmanager \
	networkmanager-nmcli \
	networkmanager-nmtui \
	asus-overlay \
	gptfdisk \
	vim \
	glibc-gconv-utf-16 \
	phytool \
	stress-ng \
"