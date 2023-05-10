FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRCBRANCH = "lf_v2.6"
ATF_SRC ?= "git://github.com/nxp-imx/imx-atf.git;protocol=https"
SRC_URI = "${ATF_SRC};branch=${SRCBRANCH} \
"

SRC_URI:append:imx8mq-im-a = "${@bb.utils.contains_any('UBOOT_CONFIG', '2G', 'file://0001-plat-imx8m-imx8mq-add-2G-support.patch', '', d)}"
SRC_URI:append:imx8mq-pe100a2g = "${@bb.utils.contains_any('UBOOT_CONFIG', '2G', 'file://0001-plat-imx8m-imx8mq-add-2G-support.patch', '', d)}"
SRC_URI:append:imx8mq-pv100a2g = "${@bb.utils.contains_any('UBOOT_CONFIG', '2G', 'file://0001-plat-imx8m-imx8mq-add-2G-support.patch', '', d)}"
SRC_URI:append:imx8mq-im-a = "${@bb.utils.contains_any('UBOOT_CONFIG', '4G', 'file://0001-plat-imx8m-imx8mq-add-4G-support.patch', '', d)}"
SRC_URI:append:imx8mq-pe100a = "${@bb.utils.contains_any('UBOOT_CONFIG', '4G', 'file://0001-plat-imx8m-imx8mq-add-4G-support.patch', '', d)}"
SRC_URI:append:imx8mq-pv100a = "${@bb.utils.contains_any('UBOOT_CONFIG', '4G', 'file://0001-plat-imx8m-imx8mq-add-4G-support.patch', '', d)}"
#SRC_URI:append:imx8mp-blizzard4g = "${@bb.utils.contains_any('UBOOT_CONFIG', '4G', 'file://0001-plat-imx8m-imx8mp-add-4G-support.patch', '', d)}"
SRC_URI:append:imx8mp-blizzard2g = "${@bb.utils.contains_any('UBOOT_CONFIG', '2G', 'file://0001-plat-imx8m-imx8mp-add-2G-support-and-disable-FF-A.patch', '', d)}"
