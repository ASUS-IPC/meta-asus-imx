DESCRIPTION = "ASUS IMX8P-IM-A overlay package"
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

inherit systemd

do_package_qa[noexec] = "1"
SYSTEMD_SERVICE_${PN} = "resize-helper.service fs-mount@.service adbd.service"
SYSTEMD_SERVICE_${PN}_imx8mq-pv100a = "resize-helper.service fs-mount@.service ntpsync.service rtcsync.service adbd.service"
RDEPENDS_${PN} = "systemd e2fsprogs-resize2fs parted"

do_install() {
  install -d ${D}
  cp -rf ${WORKDIR}/common/* ${D}
  cp -rf ${WORKDIR}/${MACHINE}/* ${D}
}

FILES_${PN} += "/ "
