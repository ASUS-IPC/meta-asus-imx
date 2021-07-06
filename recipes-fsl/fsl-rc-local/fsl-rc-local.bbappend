FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"

SRC_URI += "file://rc.local.imx8mq-pv100a \
            file://rc.local.imx8mq-pe100a \
            file://rc.local.imx8mq-pv100a2g \
"

do_install_append_imx8mq-pe100a () {
  install -m 755 ${S}/rc.local.imx8mq-pe100a ${D}/${sysconfdir}/rc.local
}

do_install_append_imx8mq-pv100a () {
  install -m 755 ${S}/rc.local.imx8mq-pv100a ${D}/${sysconfdir}/rc.local
}

do_install_append_imx8mq-pv100a2g () {
  install -m 755 ${S}/rc.local.imx8mq-pv100a2g ${D}/${sysconfdir}/rc.local
}
