#@TYPE: Machine
#@NAME: ASUS IMX8MQ board
#@SOC: i.MX8MQ
#@DESCRIPTION: Machine configuration for ASUS IMX8MQ board
#@MAINTAINER: Andy Kuo <andy3_kuo@asus.com>

MACHINEOVERRIDES =. "mx8:mx8m:mx8mq:asus:"

require conf/machine/include/imx-base.inc
require conf/machine/include/arm/arch-arm64.inc

require generate-imx-sdcard.inc

MACHINE_FEATURES += " pci bluetooth wifi optee qca6174 rtl8822"

# ASUS BSP default providers
ASUS_DEFAULT_UBOOT = "u-boot-asus-imx"
PREFERRED_PROVIDER_u-boot_asus = "${ASUS_DEFAULT_UBOOT}"
PREFERRED_PROVIDER_virtual/bootloader_asus  = "${ASUS_DEFAULT_UBOOT}"

ASUS_DEFAULT_KERNEL = "linux-asus-imx"
PREFERRED_PROVIDER_virtual/kernel_asus = "${ASUS_DEFAULT_KERNEL}"
PREFERRED_VERSION_linux-asus-imx = "4.14.98"

KERNEL_IMAGETYPE_mx8 = "Image"

KERNEL_DEVICETREE = "freescale/fsl-imx8mq-evk-ak4497.dtb "
KERNEL_DEVICETREE += "freescale/fsl-imx8mq-evk-audio-tdm.dtb freescale/fsl-imx8mq-evk-b3.dtb "
KERNEL_DEVICETREE += "freescale/fsl-imx8mq-evk-dp.dtb freescale/fsl-imx8mq-evk-edp.dtb"
KERNEL_DEVICETREE += "freescale/fsl-imx8mq-evk-inmate.dtb"
KERNEL_DEVICETREE += "freescale/fsl-imx8mq-evk-m4.dtb freescale/fsl-imx8mq-evk-mipi-csi2.dtb"
KERNEL_DEVICETREE += "freescale/fsl-imx8mq-evk-pcie1-m2.dtb freescale/fsl-imx8mq-evk-pdm.dtb"
KERNEL_DEVICETREE += "freescale/fsl-imx8mq-evk-root.dtb"
KERNEL_DEVICETREE += "freescale/fsl-imx8mq-evk-dcss-powertip.dtb"
KERNEL_DEVICETREE += "freescale/fsl-imx8mq-evk-dcss-rpi.dtb"
KERNEL_DEVICETREE += "freescale/fsl-imx8mq-evk-lcdif-powertip.dtb"
KERNEL_DEVICETREE += "freescale/fsl-imx8mq-evk-lcdif-rpi.dtb"
KERNEL_DEVICETREE += "freescale/fsl-imx8mq-evk-dual-display-powertip.dtb"
KERNEL_DEVICETREE += "freescale/fsl-imx8mq-evk-dual-display-rpi.dtb"

IMAGE_BOOTFILES_DEPENDS += "imx-m4-demos:do_deploy"
IMAGE_BOOTFILES += "imx8mq_m4_TCM_hello_world.bin imx8mq_m4_TCM_rpmsg_lite_pingpong_rtos_linux_remote.bin imx8mq_m4_TCM_rpmsg_lite_str_echo_rtos.bin"

SPL_BINARY = "spl/u-boot-spl.bin"

# Set DDR FIRMWARE
DDR_FIRMWARE_NAME = "lpddr4_pmu_train_1d_imem.bin lpddr4_pmu_train_1d_dmem.bin lpddr4_pmu_train_2d_imem.bin lpddr4_pmu_train_2d_dmem.bin"

# Set imx-mkimage boot target
IMXBOOT_TARGETS = "flash_evk flash_evk_no_hdmi flash_dp_evk"

SERIAL_CONSOLES = "115200;ttymxc0"

IMAGE_BOOTLOADER = "imx-boot"

BOOT_SPACE = "65536"

MISC_SPACE = "8192"

LOADADDR = ""
UBOOT_SUFFIX = "bin"
UBOOT_MAKE_TARGET = ""
IMX_BOOT_SEEK = "33"

SDCARD_GENERATION_COMMAND_mx8 = "generate_imx_sdcard_mx8"

DEFAULTTUNE_mx8 = "aarch64"

VOLATILE_LOG_DIR = "no"

PACKAGECONFIG_append_pn-gstreamer1.0-plugins-ugly = " x264"
PACKAGECONFIG_append_pn-networkmanager = " modemmanager ppp"

MACHINE_EXTRA_RDEPENDS += " \
	asus-overlay \
	edgetpu \
	python3-numpy \
	python3-pip \
	networkmanager \
	networkmanager-nmtui \
	gpsd \
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
	can-utils-j1939 \
	modemmanager \
	opkg \
	busybox \
"

MACHINE_EXTRA_RRECOMMENDS_append = " ${@bb.utils.contains('MACHINE_FEATURES', 'qca6174', 'kernel-module-qca6174 firmware-qca6174 firmware-qca6174-usb qca-tools', '', d)}"
MACHINE_EXTRA_RRECOMMENDS_append = " ${@bb.utils.contains('MACHINE_FEATURES', 'rtl8822', 'rtk-bt-fw', '', d)}"

IMAGE_FSTYPES = "sdcard.bz2"
