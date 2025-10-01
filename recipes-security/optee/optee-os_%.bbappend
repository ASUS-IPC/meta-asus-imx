FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

PLATFORM_FLAVOR_mx8mq-nxp-bsp = "mx8mqevk"
#PLATFORM_FLAVOR_mx8mp-nxp-bsp = "mx8mpevk"

SRC_URI:append:mx8mq-nxp-bsp = "${@bb.utils.contains_any('UBOOT_CONFIG', '2G', ' file://0001-imx-optee-os-imx8mq-add-2g-support.patch', '', d)}"
SRC_URI:append:mx8mq-nxp-bsp = "${@bb.utils.contains_any('UBOOT_CONFIG', '4G', ' file://0001-imx-optee-os-imx8mq-add-4g-support.patch', '', d)}"

# SRC_URI:append:mx8mp-nxp-bsp = "${@bb.utils.contains_any('UBOOT_CONFIG', '4G', ' file://0001-imx-optee-os-imx8mp-add-4g-support.patch', '', d)}"
#SRC_URI:append:mx8mp-nxp-bsp = "${@bb.utils.contains_any('UBOOT_CONFIG', '2G', ' file://0001-imx-optee-os-imx8mp-add-2g-support.patch', '', d)}"
