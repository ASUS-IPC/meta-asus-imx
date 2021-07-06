FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://0001-plat-imx8mq-enable-normal-peripheral-irq-wake-system.patch \
"

SRC_URI_append_imx8mq-pv100a += " \
    file://i.mx8mq_ddr_clock_ss_in_atf.patch \
"

SRC_URI_append_imx8mq-pv100a2g += " \
    file://i.mx8mq_ddr_clock_ss_in_atf.patch \
    file://0001-plat-imx8mq-add-2G-support.patch \
"
