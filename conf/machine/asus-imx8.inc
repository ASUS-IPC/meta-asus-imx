#@TYPE: Machine
#@NAME: ASUS IMX8MQ board
#@SOC: i.MX8MQ
#@DESCRIPTION: Machine configuration for ASUS IMX8MQ board
#@MAINTAINER: Singhome Lee <singhome1_lee@asus.com>

MACHINEOVERRIDES =. "mx8:mx8m:mx8mq:asus:"

require conf/machine/include/imx-base.inc
require conf/machine/include/tune-cortexa53.inc

IMX_DEFAULT_BSP = "nxp"

MACHINE_FEATURES += "pci wifi bluetooth optee bcm43455 bcm4356"
MACHINE_FEATURES_append_use-nxp-bsp = " bcm4359"

# ASUS BSP default providers
ASUS_DEFAULT_UBOOT = "u-boot-asus-imx"
PREFERRED_PROVIDER_u-boot_asus = "${ASUS_DEFAULT_UBOOT}"
PREFERRED_PROVIDER_virtual/bootloader_asus  = "${ASUS_DEFAULT_UBOOT}"

ASUS_DEFAULT_KERNEL = "linux-asus-imx"
PREFERRED_PROVIDER_virtual/kernel_asus = "${ASUS_DEFAULT_KERNEL}"
PREFERRED_VERSION_linux-asus-imx = "5.10"

MACHINE_SOCARCH_FILTER_append_mx8mq = " virtual/libopenvg virtual/libgles1 virtual/libgles2 virtual/egl virtual/mesa virtual/libgl virtual/libg2d"

KERNEL_DEVICETREE = " \
	freescale/imx8mq-evk.dtb \
"
KERNEL_DEVICETREE_append_use-nxp-bsp = " \
	freescale/imx8mq-evk-ak4497.dtb \
	freescale/imx8mq-evk-audio-tdm.dtb \
	freescale/imx8mq-evk-dcss-adv7535.dtb \
	freescale/imx8mq-evk-dcss-rm67191.dtb \
	freescale/imx8mq-evk-dcss-rm67199.dtb \
	freescale/imx8mq-evk-dp.dtb \
	freescale/imx8mq-evk-dual-display.dtb \
	freescale/imx8mq-evk-inmate.dtb \
	freescale/imx8mq-evk-lcdif-adv7535.dtb \
	freescale/imx8mq-evk-lcdif-rm67191.dtb \
	freescale/imx8mq-evk-lcdif-rm67199.dtb \
	freescale/imx8mq-evk-pcie-ep.dtb \
	freescale/imx8mq-evk-pcie1-m2.dtb \
	freescale/imx8mq-evk-pdm.dtb \
	freescale/imx8mq-evk-root.dtb \
	freescale/imx8mq-evk-rpmsg.dtb \
	freescale/imx8mq-evk-usd-wifi.dtb \
	freescale/imx8mq-evk-usdhc2-m2.dtb \
"

UBOOT_SUFFIX = "bin"

SPL_BINARY = "spl/u-boot-spl.bin"

# Set DDR FIRMWARE
DDR_FIRMWARE_NAME = " \
    lpddr4_pmu_train_1d_imem.bin \
    lpddr4_pmu_train_1d_dmem.bin \
    lpddr4_pmu_train_2d_imem.bin \
    lpddr4_pmu_train_2d_dmem.bin \
"

# Set ATF platform name
ATF_PLATFORM = "imx8mq"

# Set imx-mkimage boot target
IMXBOOT_TARGETS = "flash_evk flash_evk_no_hdmi flash_dp_evk"
IMX_BOOT_SOC_TARGET = "iMX8M"

LOADADDR = ""
UBOOT_SUFFIX = "bin"
UBOOT_MAKE_TARGET = ""
IMX_BOOT_SEEK = "33"

OPTEE_BIN_EXT = "8mq"

# Add additional firmware
MACHINE_FIRMWARE_append = " linux-firmware-ath10k"

# Set Serial console
SERIAL_CONSOLES = "115200;ttymxc0"

IMAGE_INSTALL_append += " \
	asus-overlay \
	gptfdisk \
	vim \
"

SOC_DEFAULT_WKS_FILE_asus = "asus-imx-boot-bootpart.wks.in"

IMAGE_FSTYPES = "wic.bz2"
