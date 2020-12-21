FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"

SRC_URI += "file://rc.local.imx8mq-pv100a \
"

do_install_append_imx8mq-pv100a () {
  install -m 755 ${S}/rc.local.imx8mq-pv100a ${D}/${sysconfdir}/rc.local
}
