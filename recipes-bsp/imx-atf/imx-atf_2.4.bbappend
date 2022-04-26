FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append_imx8mq-im-a += "${@bb.utils.contains_any('UBOOT_CONFIG', '2G', 'file://0001-plat-imx8m-imx8mq-add-2G-support.patch', '', d)}"
SRC_URI_append_imx8mq-pe100a += "${@bb.utils.contains_any('UBOOT_CONFIG', '2G', 'file://0001-plat-imx8m-imx8mq-add-2G-support.patch', '', d)}"
SRC_URI_append_imx8mq-pv100a += "${@bb.utils.contains_any('UBOOT_CONFIG', '2G', 'file://0001-plat-imx8m-imx8mq-add-2G-support.patch', '', d)}"
SRC_URI_append_imx8mq-im-a += "${@bb.utils.contains_any('UBOOT_CONFIG', '4G', 'file://0001-plat-imx8m-imx8mq-add-4G-support.patch', '', d)}"
SRC_URI_append_imx8mq-pe100a += "${@bb.utils.contains_any('UBOOT_CONFIG', '4G', 'file://0001-plat-imx8m-imx8mq-add-4G-support.patch', '', d)}"
SRC_URI_append_imx8mq-pv100a += "${@bb.utils.contains_any('UBOOT_CONFIG', '4G', 'file://0001-plat-imx8m-imx8mq-add-4G-support.patch', '', d)}"
# SRC_URI_append_imx8mp-blizzard4g += "${@bb.utils.contains_any('UBOOT_CONFIG', '4G', 'file://0001-plat-imx8m-imx8mp-add-4G-support.patch', '', d)}"
# SRC_URI_append_imx8mp-blizzard2g += "${@bb.utils.contains_any('UBOOT_CONFIG', '2G', 'file://0001-plat-imx8m-imx8mp-add-2G-support.patch', '', d)}