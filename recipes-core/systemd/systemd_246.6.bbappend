FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"

SRC_URI += "file://system.conf \
            file://logind.conf \
            file://reboot.target \
            file://poweroff.target \
            file://systemd-reboot.service \
            file://systemd-poweroff.service \
            file://systemd-reboot.service.imx8mq-pv100a \
            file://systemd-poweroff.service.imx8mq-pv100a \
"

SYSTEMD_REBOOT = "systemd-reboot.service"
SYSTEMD_POWEROFF = "systemd-poweroff.service"
SYSTEMD_REBOOT_imx8mq-pv100a = "systemd-reboot.service.imx8mq-pv100a"
SYSTEMD_POWEROFF_imx8mq-pv100a = "systemd-poweroff.service.imx8mq-pv100a"

ALTERNATIVE_PRIORITY[resolv-conf] = "150"

do_install_append () {
  install -m 0644 ${WORKDIR}/system.conf ${D}${sysconfdir}/systemd
  install -m 0644 ${WORKDIR}/logind.conf ${D}${sysconfdir}/systemd
  install -m 0644 ${WORKDIR}/reboot.target ${D}${base_libdir}/systemd/system
  install -m 0644 ${WORKDIR}/poweroff.target ${D}${base_libdir}/systemd/system
  install -m 0644 ${WORKDIR}/${SYSTEMD_REBOOT} ${D}${base_libdir}/systemd/system/systemd-reboot.service
  install -m 0644 ${WORKDIR}/${SYSTEMD_POWEROFF} ${D}${base_libdir}/systemd/system/systemd-poweroff.service
}
