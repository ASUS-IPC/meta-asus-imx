DESCRIPTION = "ASUS overlay package"
PR = "r2"
SRC_URI = "file://common \
           file://imx8mq-im-a \
           file://imx8mq-pe100a \
           file://imx8mq-pv100a \
           file://COPYING \
"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${WORKDIR}/COPYING;md5=d32239bcb673463ab874e80d47fae504"

INSANE_SKIP_${PN} = "stripped"
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"

FILES_SOLIBSDEV = ""
INSANE_SKIP_${PN} += "dev-so"

inherit systemd

do_package_qa[noexec] = "1"
SYSTEMD_SERVICE_${PN} = "resize-helper.service adbd.service asus_failover.service mm_keepalive.service"
SYSTEMD_SERVICE_${PN}_imx8mq-pv100a = "resize-helper.service adbd.service asus_failover.service mm_keepalive.service"
RDEPENDS_${PN} = "systemd e2fsprogs-resize2fs parted"

do_install() {
  install -d ${D}
  cp -rf ${WORKDIR}/common/* ${D}
  cp -rf ${WORKDIR}/${MACHINE}/* ${D}
}


FILES_${PN} += "/ "
