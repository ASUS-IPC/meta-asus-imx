MACHINEOVERRIDES =. "mx8mp:asus:"

# FIXME: u-boot-imx should be converted to `binman` and then we can
# avoid this specific overrides and handle it in a generic way.
MACHINEOVERRIDES =. "${@bb.utils.contains('IMX_DEFAULT_BOOTLOADER', 'u-boot-imx', '', 'imx-boot-container:', d)}"

require conf/machine/include/imx-base.inc
require conf/machine/include/arm/armv8a/tune-cortexa53.inc

# Mainline BSP defaults to "generic" cortexa53 configuration,
# adjust it here to include crypto extension which enables
# inline NEON and FPU code generation
DEFAULTTUNE:use-mainline-bsp = "cortexa53-crypto"

MACHINE_FEATURES += "pci wifi bluetooth"

# NXP BSP can consume proprietary jailhouse and Marvell drivers
# OP-TEE is also applicable to NXP BSP, mainline BSP seems not to have
# a full support for it yet.
MACHINE_FEATURES:append:use-nxp-bsp = " optee jailhouse mrvl8997"

# Mainline kernel contains only one DTB file for
# imx8mpevk machine
KERNEL_DEVICETREE = " \
    freescale/${KERNEL_DEVICETREE_BASENAME}.dtb \
    freescale/imx8mp-blizzard-evt.dtb \
"

UBOOT_DTB_NAME = "${KERNEL_DEVICETREE_BASENAME}.dtb"

# ASUS BSP default providers
#IMX_DEFAULT_MFGTOOL = "${@bb.utils.contains('IMX_DEFAULT_BOOTLOADER', 'u-boot-imx','u-boot-imx-mfgtool', 'u-boot-fslc', d)}"
ASUS_DEFAULT_UBOOT = "u-boot-asus-imx"
PREFERRED_PROVIDER_u-boot:asus = "${ASUS_DEFAULT_UBOOT}"
# PREFERRED_PROVIDER_u-boot-mfgtool ??= "${IMX_DEFAULT_MFGTOOL}"
PREFERRED_PROVIDER_u-boot-mfgtool:asus = "u-boot-asus-imx-mfgtool"
PREFERRED_PROVIDER_virtual/bootloader:asus  = "${ASUS_DEFAULT_UBOOT}"

ASUS_DEFAULT_KERNEL = "linux-asus-imx"
PREFERRED_PROVIDER_virtual/kernel:asus = "${ASUS_DEFAULT_KERNEL}"
PREFERRED_VERSION_linux-asus-imx = "5.15"

#IMX_DEFAULT_BOOTLOADER_use-nxp-bsp = "u-boot-imx"
#IMX_DEFAULT_BOOTLOADER_use-mainline-bsp = "u-boot-fslc"

UBOOT_SUFFIX = "bin"

SPL_BINARY = "spl/u-boot-spl.bin"

ATF_PLATFORM = "imx8mp"

IMXBOOT_TARGETS = \
    "${@bb.utils.contains('UBOOT_CONFIG', 'fspi', '${IMXBOOT_TARGETS_BASENAME}_flexspi', \
                                                  '${IMXBOOT_TARGETS_BASENAME}', d)}"

IMX_BOOT_SOC_TARGET = "iMX8MP"

SERIAL_CONSOLES = "115200;ttymxc1"

# Add support for Syslinux to mainline BSP.
# U-Boot has the Distro Boot mode enabled by default, which
# require that either Syslinux to be enabled, or a boot script
# to be used to define the boot process.
# We opt-in for Syslinux, since it is designated as a preferred
# distro boot mode according to the U-Boot documentation.
UBOOT_EXTLINUX:use-mainline-bsp = "1"
UBOOT_EXTLINUX_LABELS:use-mainline-bsp = "default"
UBOOT_EXTLINUX_DEFAULT_LABEL:use-mainline-bsp = "i.MX8M Plus EVK"

UBOOT_EXTLINUX_MENU_DESCRIPTION:default:use-mainline-bsp = "i.MX8M Plus EVK"
UBOOT_EXTLINUX_FDT:default:use-mainline-bsp     = "../${KERNEL_DEVICETREE_BASENAME}.dtb"
UBOOT_EXTLINUX_CONSOLE:default:use-mainline-bsp = "console=${console}"
UBOOT_EXTLINUX_ROOT:default:use-mainline-bsp    = "root=/dev/mmcblk1p3"

# Add extlinux.conf to the lis of files, which are deployed onto the
# boot partition
IMAGE_BOOT_FILES:append:use-mainline-bsp = " extlinux.conf;extlinux/extlinux.conf"

LOADADDR = ""
UBOOT_MAKE_TARGET = "all"
IMX_BOOT_SEEK = "32"

OPTEE_BIN_EXT = "8mp"
TEE_LOAD_ADDR = "0x56000000"

VOLATILE_LOG_DIR = "no"

# Add additional firmware
MACHINE_FIRMWARE:append = " linux-firmware-ath10k"
