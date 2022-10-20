# Copyright (C) 2022 Asus
# Released under the MIT license (see COPYING.MIT for the terms)

SUMMARY = "imx-image-full with a couple additions by Asus"
LICENSE = "MIT"

IMAGE_INSTALL += " \
	asus-overlay \
	can-utils \
	glibc-gconv-utf-16 \
	gptfdisk \
	networkmanager \
	networkmanager-nmcli \
	networkmanager-nmtui \
	vim \
	phytool \
"
