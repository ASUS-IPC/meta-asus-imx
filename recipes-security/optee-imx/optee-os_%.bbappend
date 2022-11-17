FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

OPTEE_OS_SRC ?= "git://github.com/nxp-imx/imx-optee-os.git;protocol=https"
SRCBRANCH = "lf-5.15.52_2.1.0"
SRC_URI = "${OPTEE_OS_SRC};branch=${SRCBRANCH} \
"

PLATFORM_FLAVOR_mx8mq-nxp-bsp = "mx8mqevk"
PLATFORM_FLAVOR_mx8mp-nxp-bsp = "mx8mpevk"

SRC_URI:append:mx8mq-nxp-bsp = "${@bb.utils.contains_any('UBOOT_CONFIG', '2G', 'file://0001-imx-optee-os-imx8mq-add-2g-support.patch', '', d)}"
SRC_URI:append:mx8mq-nxp-bsp = "${@bb.utils.contains_any('UBOOT_CONFIG', '4G', 'file://0001-imx-optee-os-imx8mq-add-4g-support.patch', '', d)}"

# SRC_URI:append:mx8mp-nxp-bsp = "${@bb.utils.contains_any('UBOOT_CONFIG', '4G', 'file://0001-imx-optee-os-imx8mp-add-4g-support.patch', '', d)}"
SRC_URI:append:mx8mp-nxp-bsp = "${@bb.utils.contains_any('UBOOT_CONFIG', '2G', 'file://0001-imx-optee-os-imx8mp-add-2g-support.patch', '', d)}"
