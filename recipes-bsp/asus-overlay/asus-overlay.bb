DESCRIPTION = "ASUS overlay package"
PR = "r2"
SRC_URI = "file://common \
           file://imx8mq-im-a \
           file://imx8mq-pe100a \
           file://imx8mq-pe100a2g \
           file://imx8mq-pv100a \
           file://imx8mq-pv100a2g \
           file://blizzard_common \
           file://imx8mp-blizzard \
           file://imx8mp-blizzard4g \
           file://imx8mp-blizzard2g \
           file://COPYING \
"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${WORKDIR}/COPYING;md5=d32239bcb673463ab874e80d47fae504"

INSANE_SKIP:${PN} = "stripped"
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"

FILES_SOLIBSDEV = ""
INSANE_SKIP:${PN} += "dev-so"

inherit systemd

do_package_qa[noexec] = "1"
SYSTEMD_SERVICE:${PN} = "resize-helper.service adbd.service asus_failover.service mm_keepalive.service EdgeX.service PruneDocker.timer"
SYSTEMD_SERVICE:${PN}:imx8mp-blizzard = "resize-helper.service adbd.service"
SYSTEMD_SERVICE:${PN}:imx8mp-blizzard4g = "resize-helper.service adbd.service"
SYSTEMD_SERVICE:${PN}:imx8mp-blizzard2g = "resize-helper.service adbd.service"
SYSTEMD_SERVICE:${PN}:imx8mq-pv100a = "resize-helper.service adbd.service asus_failover.service mm_keepalive.service ntpsync.service rtcsync.service EdgeX.service mcu_daemon.service PruneDocker.timer"
SYSTEMD_SERVICE:${PN}:imx8mq-pv100a2g = "resize-helper.service adbd.service asus_failover.service mm_keepalive.service ntpsync.service rtcsync.service EdgeX.service mcu_daemon.service PruneDocker.timer"

SYSTEMD_SERVICE:${PN} += "${@bb.utils.contains_any('ROOTFS_OVERLAY_ENABLED', 'ENABLED', 'overlayetc.service', '', d)}"
SYSTEMD_SERVICE:${PN} += "${@bb.utils.contains_any('FOTA_ENABLED', 'ENABLED', 'fotaclient.service', '', d)}"

RDEPENDS:${PN} = "systemd e2fsprogs-resize2fs parted"

do_install:append() {
  install -d ${D}

  if [ "${MACHINE}" = "imx8mp-blizzard" ] || [ "${MACHINE}" = "imx8mp-blizzard4g" ] || [ "${MACHINE}" = "imx8mp-blizzard2g" ]; then
	if [ -n "$(ls -A ${WORKDIR}/blizzard_common)" ]; then
		cp -rf ${WORKDIR}/blizzard_common/* ${D}
	fi
  else
        if [ "${MACHINE}" = "imx8mq-pe100a2g" ] || [ "${MACHINE}" = "imx8mq-pe100a" ] || [ "${MACHINE}" = "imx8mq-im-a" ];then
                cp -rf ${WORKDIR}/${MACHINE}/* ${D}
        fi
	if [ -n "$(ls -A ${WORKDIR}/common)" ]; then
		cp -rf ${WORKDIR}/common/* ${D}
	fi
  fi
  if [ -n "$(ls -A ${WORKDIR}/${MACHINE})" ]; then
    cp -rf ${WORKDIR}/${MACHINE}/* ${D}
  fi
}

FILES:${PN} += "/"
