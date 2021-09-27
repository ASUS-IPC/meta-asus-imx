#@TYPE: Machine
#@NAME: ASUS IMX8MQ board
#@SOC: i.MX8MQ
#@DESCRIPTION: Machine configuration for ASUS IMX8MQ board
#@MAINTAINER: Andy Kuo <andy3_kuo@asus.com>

MACHINEOVERRIDES =. "mx8:mx8m:mx8mq:asus:"

require conf/machine/include/imx-base.inc
require conf/machine/include/tune-cortexa53.inc

MACHINE_FEATURES += " pci bluetooth wifi rtl8822 qca6174 ax200 optee"

# ASUS BSP default providers
ASUS_DEFAULT_UBOOT = "u-boot-asus-imx"
PREFERRED_PROVIDER_u-boot_asus = "${ASUS_DEFAULT_UBOOT}"
PREFERRED_PROVIDER_virtual/bootloader_asus  = "${ASUS_DEFAULT_UBOOT}"

ASUS_DEFAULT_KERNEL = "linux-asus-imx"
PREFERRED_PROVIDER_virtual/kernel_asus = "${ASUS_DEFAULT_KERNEL}"
PREFERRED_VERSION_linux-asus-imx = "5.10"

IMX_DEFAULT_BSP = "nxp"
MACHINE_SOCARCH_FILTER_append_mx8mq = " virtual/libopenvg virtual/libgles1 virtual/libgles2 virtual/egl virtual/mesa virtual/libgl virtual/libg2d"

KERNEL_DEVICETREE = " \
	freescale/imx8mq-evk-ak4497.dtb \
	freescale/imx8mq-evk-audio-tdm.dtb \
	freescale/imx8mq-evk-dcss-adv7535.dtb \
	freescale/imx8mq-evk-dcss-rm67191.dtb \
	freescale/imx8mq-evk-dp.dtb \
	freescale/imx8mq-evk-dual-display.dtb \
	freescale/imx8mq-evk-inmate.dtb \
	freescale/imx8mq-evk-lcdif-adv7535.dtb \
	freescale/imx8mq-evk-lcdif-rm67191.dtb \
	freescale/imx8mq-evk-pcie1-m2.dtb \
	freescale/imx8mq-evk-pdm.dtb \
	freescale/imx8mq-evk-root.dtb \
	freescale/imx8mq-evk-rpmsg.dtb \
"

SPL_BINARY = "spl/u-boot-spl.bin"

# Set DDR FIRMWARE
DDR_FIRMWARE_NAME = "lpddr4_pmu_train_1d_imem.bin lpddr4_pmu_train_1d_dmem.bin lpddr4_pmu_train_2d_imem.bin lpddr4_pmu_train_2d_dmem.bin"

# Set imx-mkimage boot target
IMXBOOT_TARGETS = "flash_evk flash_evk_no_hdmi flash_dp_evk"

# Set Serial console
SERIAL_CONSOLES = "115200;ttymxc0"

LOADADDR = ""
UBOOT_SUFFIX = "bin"
UBOOT_MAKE_TARGET = ""
IMX_BOOT_SEEK = "33"

OPTEE_BIN_EXT = "8mq"

# Add additional firmware
MACHINE_FIRMWARE_append = " linux-firmware-ath10k"

# Use gstreamer 1.16 from meta-freescale
PREFERRED_VERSION_gstreamer1.0 ?= "1.16.imx"
PREFERRED_VERSION_gstreamer1.0-plugins-base ?= "1.16.imx"
PREFERRED_VERSION_gstreamer1.0-plugins-good ?= "1.16.imx"
PREFERRED_VERSION_gstreamer1.0-plugins-bad ?= "1.16.imx"
PREFERRED_VERSION_gstreamer1.0-libav ?= "1.16.0"

VOLATILE_LOG_DIR = "no"

PACKAGECONFIG_append_pn-gstreamer1.0-plugins-ugly = " x264"
PACKAGECONFIG_append_pn-networkmanager = " modemmanager ppp"

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
	tpm2-tools \
"

MACHINE_EXTRA_RRECOMMENDS_append = " ${@bb.utils.contains('MACHINE_FEATURES', 'qca6174', 'kernel-module-qca6174 firmware-qca6174 firmware-qca6174-usb qca-tools', '', d)}"
MACHINE_EXTRA_RRECOMMENDS_append = " ${@bb.utils.contains('MACHINE_FEATURES', 'rtl8822', 'rtk-bt-fw', '', d)}"
MACHINE_EXTRA_RRECOMMENDS_append = " ${@bb.utils.contains('MACHINE_FEATURES', 'ax200', 'firmware-intel', '', d)}"

SOC_DEFAULT_WKS_FILE_asus = "asus-imx-boot-bootpart.wks.in"

IMAGE_FSTYPES = "wic.bz2"
