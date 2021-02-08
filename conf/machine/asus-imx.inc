MACHINE_FEATURES += " pci bluetooth wifi optee qca6174 rtl8822"

# ASUS BSP default providers
ASUS_DEFAULT_UBOOT = "u-boot-asus-imx"
PREFERRED_PROVIDER_u-boot_asus = "${ASUS_DEFAULT_UBOOT}"
PREFERRED_PROVIDER_virtual/bootloader_asus  = "${ASUS_DEFAULT_UBOOT}"

ASUS_DEFAULT_KERNEL = "linux-asus-imx"
PREFERRED_PROVIDER_virtual/kernel_asus = "${ASUS_DEFAULT_KERNEL}"
PREFERRED_VERSION_linux-asus-imx = "4.14.98"

KERNEL_IMAGETYPE_mx8 = "Image"

SDCARD_GENERATION_COMMAND_mx8 = "generate_imx_sdcard_mx8"

DEFAULTTUNE_mx8 = "aarch64"

VOLATILE_LOG_DIR = "no"

PACKAGECONFIG_append_pn-gstreamer1.0-plugins-ugly = " x264"

MACHINE_EXTRA_RDEPENDS += " \
	asus-overlay \
	edgetpu \
	python3-numpy \
	python3-pip \
	networkmanager \
	networkmanager-nmtui \
	gpsd \
	samba \
	exfat-utils \
	fuse-exfat \
	ntfs-3g \
	gptfdisk \
	vim \
	whiptail \
	gstreamer1.0-libav \
	gstreamer1.0-plugins-ugly \
	glibc-utils \
	glibc-gconv-utf-16 \
	localedef \
	cmake \
	packagegroup-core-buildessential \
	iotedge-daemon \
	iotedge-cli \
	docker \
	docker-contrib \
	ca-certificates \
	ppp \
	libqmi \
	libmbim \
	canopensocket \
"

MACHINE_EXTRA_RRECOMMENDS_append = " ${@bb.utils.contains('MACHINE_FEATURES', 'qca6174', 'kernel-module-qca6174 firmware-qca6174 firmware-qca6174-usb qca-tools', '', d)}"
MACHINE_EXTRA_RRECOMMENDS_append = " ${@bb.utils.contains('MACHINE_FEATURES', 'rtl8822', 'rtk-bt-fw', '', d)}"

IMAGE_FSTYPES = "sdcard.bz2"
