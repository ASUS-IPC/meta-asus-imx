DESCRIPTION = "ASUS IMX8P-IM-A overlay package"
PR = "r2"
SRC_URI = "file://common \
           file://imx8mq-im-a \
           file://imx8mq-pe100a \
           file://imx8mq-pe100a2g \
           file://imx8mq-pv100a \
           file://imx8mq-pv100a2g \
           file://COPYING \
"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${WORKDIR}/COPYING;md5=d32239bcb673463ab874e80d47fae504"

INSANE_SKIP_${PN} = "stripped"
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"

inherit systemd

do_package_qa[noexec] = "1"
SYSTEMD_SERVICE_${PN} = "fs-mount@.service adbd.service"
SYSTEMD_SERVICE_${PN}_imx8mq-pv100a = "fs-mount@.service ntpsync.service rtcsync.service adbd.service mm_keepalive.service"
SYSTEMD_SERVICE_${PN}_imx8mq-pv100a2g = "fs-mount@.service ntpsync.service rtcsync.service adbd.service mm_keepalive.service"
RDEPENDS_${PN} = "systemd e2fsprogs-resize2fs parted"

do_install() {
  install -d ${D}
  if [ -n "$(ls -A ${WORKDIR}/common)" ]; then
    cp -rf ${WORKDIR}/common/* ${D}
  fi
  if [ -n "$(ls -A ${WORKDIR}/${MACHINE})" ]; then
    cp -rf ${WORKDIR}/${MACHINE}/* ${D}
  fi

  install -d ${D}${sysconfdir}/systemd/system/basic.target.wants/
  ln -sf ${systemd_unitdir}/system/resize-helper.service ${D}${sysconfdir}/systemd/system/basic.target.wants/resize-helper.service
}

FILES_${PN} += "/ "
