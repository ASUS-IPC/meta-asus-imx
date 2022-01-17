FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

#SRC_URI_append += "${@bb.utils.contains_any('UBOOT_CONFIG', '2G', 'file://0001-plat-imx8m-imx8mq-add-2G-support.patch', '', d)}"
#SRC_URI_append += "${@bb.utils.contains_any('UBOOT_CONFIG', '4G', 'file://0001-plat-imx8m-imx8mq-add-4G-support.patch', '', d)}"
