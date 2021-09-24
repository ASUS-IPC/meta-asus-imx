FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append += "${@bb.utils.contains_any('UBOOT_CONFIG', '2G', 'file://0001-plat-imx8mq-add-2G-support.patch', '', d)}"

SRC_URI_append += "${@bb.utils.contains_any('MACHINE', 'imx8mq-pv100a', 'file://i.mx8mq_ddr_clock_ss_in_atf.patch', '', d)}"
SRC_URI_append += "${@bb.utils.contains_any('MACHINE', 'imx8mq-pv100a2g', 'file://i.mx8mq_ddr_clock_ss_in_atf.patch', '', d)}"
