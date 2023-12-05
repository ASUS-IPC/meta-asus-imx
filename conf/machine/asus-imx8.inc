#@TYPE: Machine
#@NAME: NXP i.MX 8M Quad EVK
#@SOC: i.MX8MQ
#@DESCRIPTION: Machine configuration for NXP i.MX 8M Quad Evaluation Kit
#@MAINTAINER: Jun Zhu <junzhu@nxp.com>

MACHINEOVERRIDES =. "mx8mq:asus:"

# FIXME: u-boot-imx should be converted to `binman` and then we can
# avoid this specific overrides and handle it in a generic way.
MACHINEOVERRIDES =. "${@bb.utils.contains('IMX_DEFAULT_BOOTLOADER', 'u-boot-imx', '', 'imx-boot-container:', d)}"

require conf/machine/include/imx-base.inc
require conf/machine/include/arm/armv8a/tune-cortexa53.inc

# Mainline BSP defaults to "generic" cortexa53 configuration,
# adjust it here to include crypto extension which enables
# inline NEON and FPU code generation
DEFAULTTUNE:use-mainline-bsp = "cortexa53-crypto"

MACHINE_FEATURES += "pci wifi bluetooth bcm43455 bcm4356"
MACHINE_FEATURES:append:use-nxp-bsp = " optee bcm4359"

# ASUS BSP default providers
ASUS_DEFAULT_UBOOT = "u-boot-asus-imx"
PREFERRED_PROVIDER_u-boot:asus = "${ASUS_DEFAULT_UBOOT}"
PREFERRED_PROVIDER_virtual/bootloader:asus  = "${ASUS_DEFAULT_UBOOT}"

PREFERRED_PROVIDER_u-boot-mfgtool:asus = "u-boot-asus-imx-mfgtool"

ASUS_DEFAULT_KERNEL = "linux-asus-imx"
PREFERRED_PROVIDER_virtual/kernel:asus = "${ASUS_DEFAULT_KERNEL}"
PREFERRED_VERSION_linux-asus-imx = "5.15"
PREFERRED_RPROVIDER_kernel-module-imx-gpu-viv = "kernel-module-imx-gpu-viv"

MACHINE_SOCARCH_FILTER:append:mx8mq = " virtual/libopenvg virtual/libgles1 virtual/libgles2 virtual/egl virtual/mesa virtual/libgl virtual/libg2d"

KERNEL_DEVICETREE = " \
	freescale/imx8mq-evk.dtb \
"
KERNEL_DEVICETREE:append:use-nxp-bsp = " \
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
	freescale/imx8mq-pe100a-rs232.dtbo \
	freescale/imx8mq-pe100a-rs485.dtbo \
	freescale/imx8mq-pv100a-rs232.dtbo \
	freescale/imx8mq-pv100a-rs485.dtbo \
"

IMX_DEFAULT_BOOTLOADER:use-nxp-bsp = "u-boot-imx"
IMX_DEFAULT_BOOTLOADER:use-mainline-bsp = "u-boot-fslc"

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

# Add support for Syslinux to mainline BSP.
# U-Boot has the Distro Boot mode enabled by default, which
# require that either Syslinux to be enabled, or a boot script
# to be used to define the boot process.
# We opt-in for Syslinux, since it is designated as a preferred
# distro boot mode according to the U-Boot documentation.
UBOOT_EXTLINUX:use-mainline-bsp = "1"
UBOOT_EXTLINUX_LABELS:use-mainline-bsp = "default"
UBOOT_EXTLINUX_DEFAULT_LABEL:use-mainline-bsp = "i.MX8M Quad EVK"

UBOOT_EXTLINUX_MENU_DESCRIPTION:default:use-mainline-bsp = "i.MX8M Quad EVK"
UBOOT_EXTLINUX_FDT:default:use-mainline-bsp     = "../imx8mq-evk.dtb"
UBOOT_EXTLINUX_CONSOLE:default:use-mainline-bsp = "console=${console}"
UBOOT_EXTLINUX_ROOT:default:use-mainline-bsp    ??= "root=/dev/mmcblk1p2"

# Add extlinux.conf to the lis of files, which are deployed onto the
# boot partition
IMAGE_BOOT_FILES:append:use-mainline-bsp = " extlinux.conf;extlinux/extlinux.conf"

LOADADDR = ""
UBOOT_MAKE_TARGET = ""
IMX_BOOT_SEEK = "33"

OPTEE_BIN_EXT = "8mq"

# Add additional firmware
MACHINE_FIRMWARE:append = " linux-firmware-ath10k linux-firmware-rtw88 linux-firmware-qca linux-firmware-rtlbt"

# Set Serial console
SERIAL_CONSOLES = "115200;ttymxc0"

VOLATILE_LOG_DIR = "no"

PACKAGECONFIG:append:pn-modemmanager = " at"
PACKAGECONFIG:append:pn-networkmanager = " modemmanager ppp"

#SOC_DEFAULT_WKS_FILE = "${@bb.utils.contains_any('ROOTFS_OVERLAY_ENABLED', 'enabled', 'asus-imx-boot-bootpart-overlay.wks.in', 'asus-imx-boot-bootpart.wks.in', d)}"
SOC_DEFAULT_WKS_FILE:asus = "${@bb.utils.contains_any('ROOTFS_OVERLAY_ENABLED', 'ENABLED', 'asus-imx-boot-bootpart-overlay.wks.in', 'asus-imx-boot-bootpart.wks.in', d)}"

# IMAGE_FSTYPES = "wic.bz2"
