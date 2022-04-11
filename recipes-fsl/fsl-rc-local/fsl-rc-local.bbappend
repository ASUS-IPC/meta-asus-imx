FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"

SRC_URI += "file://rc.local.imx8mq-im-a \
            file://rc.local.imx8mq-pe100a \
            file://rc.local.imx8mq-pe100a2g \
            file://rc.local.imx8mq-pv100a \
            file://rc.local.imx8mq-pv100a2g \
            file://rc.local.imx8mp-blizzard \
            file://rc.local.imx8mp-blizzard4g \
"

do_install_append () {
  install -m 755 ${S}/rc.local.${MACHINE} ${D}/${sysconfdir}/rc.local
}
