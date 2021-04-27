FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append_imx8mq-pv100a += "file://i.mx8mq_ddr_clock_ss_in_atf.patch"

