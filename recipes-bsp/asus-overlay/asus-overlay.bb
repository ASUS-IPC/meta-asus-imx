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
SYSTEMD_SERVICE_${PN} = "resize-helper.service adbd.service"
SYSTEMD_SERVICE_${PN}_imx8mq-pv100a = "resize-helper.service adbd.service"
RDEPENDS_${PN} = "systemd e2fsprogs-resize2fs parted tpm2-tss"

do_install() {
  install -d ${D}
  cp -rf ${WORKDIR}/common/* ${D}
  cp -rf ${WORKDIR}/${MACHINE}/* ${D}

  if [ -n "$(ls -A ${WORKDIR}/../../../cortexa53-crypto-poky-linux/tpm2-tss/3.0.0-r0/sysroot-destdir/usr/lib)" ]; then
    cp -rf ${WORKDIR}/../../../cortexa53-crypto-poky-linux/tpm2-tss/3.0.0-r0/sysroot-destdir/usr/lib/lib* ${D}/lib
  fi
}


FILES_${PN} += "/ "
