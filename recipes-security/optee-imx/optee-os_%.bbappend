FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

PLATFORM_FLAVOR_mx8mq = "mx8mqevk"

#SRC_URI_append += "${@bb.utils.contains_any('UBOOT_CONFIG', '2G', 'file://0001-imx-optee-os-imx8mq-add-2g-support.patch', '', d)}"
#SRC_URI_append += "${@bb.utils.contains_any('UBOOT_CONFIG', '4G', 'file://0001-imx-optee-os-imx8mq-add-4g-support.patch', '', d)}"
