FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI = "${ATF_SRC};branch=${SRCBRANCH}"
ATF_SRC ?= "git://github.com/nxp-imx/imx-atf.git;protocol=https"
SRCBRANCH = "lf_v2.10"
SRCREV = "49143a1701d9ccd3239e3f95f3042897ca889ea8"

SRC_URI:append:imx8mq-im-a = "${@bb.utils.contains_any('UBOOT_CONFIG', '2G', ' file://0001-plat-imx8m-imx8mq-add-2G-support.patch', '', d)}"
SRC_URI:append:imx8mq-pe100a2g = "${@bb.utils.contains_any('UBOOT_CONFIG', '2G', ' file://0001-plat-imx8m-imx8mq-add-2G-support.patch', '', d)}"
SRC_URI:append:imx8mq-pv100a2g = "${@bb.utils.contains_any('UBOOT_CONFIG', '2G', ' file://0001-plat-imx8m-imx8mq-add-2G-support.patch \
                                                                                  file://0001-ddr-imx8mq-Enable-the-ddr-Spread-Spectrum-Clocking.patch', '', d)}"
SRC_URI:append:imx8mq-im-a = "${@bb.utils.contains_any('UBOOT_CONFIG', '4G', ' file://0001-plat-imx8m-imx8mq-add-4G-support.patch', '', d)}"
SRC_URI:append:imx8mq-pe100a = "${@bb.utils.contains_any('UBOOT_CONFIG', '4G', ' file://0001-plat-imx8m-imx8mq-add-4G-support.patch', '', d)}"
SRC_URI:append:imx8mq-pv100a = "${@bb.utils.contains_any('UBOOT_CONFIG', '4G', ' file://0001-plat-imx8m-imx8mq-add-4G-support.patch \
                                                                                file://0001-ddr-imx8mq-Enable-the-ddr-Spread-Spectrum-Clocking.patch', '', d)}"