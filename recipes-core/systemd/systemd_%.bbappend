FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"

SRC_URI += "file://system.conf \
            file://system.conf.imx8mq-pv100a \
            file://logind.conf \
            file://reboot.target \
            file://poweroff.target \
            file://systemd-reboot.service \
            file://systemd-poweroff.service \
            file://50-tpu-pm.sh \
"

do_install_append () {
  install -m 0644 ${WORKDIR}/system.conf ${D}${sysconfdir}/systemd
  install -m 0644 ${WORKDIR}/logind.conf ${D}${sysconfdir}/systemd
  install -m 0644 ${WORKDIR}/reboot.target ${D}${base_libdir}/systemd/system
  install -m 0644 ${WORKDIR}/poweroff.target ${D}${base_libdir}/systemd/system
  install -m 0644 ${WORKDIR}/systemd-reboot.service ${D}${base_libdir}/systemd/system
  install -m 0644 ${WORKDIR}/systemd-poweroff.service ${D}${base_libdir}/systemd/system
  install -m 0755 ${WORKDIR}/50-tpu-pm.sh ${D}${base_libdir}/systemd/system-sleep
}

do_install_append_imx8mq-pv100a () {
  install -m 0644 ${WORKDIR}/system.conf.imx8mq-pv100a ${D}${sysconfdir}/systemd/system.conf
}

do_install_append_imx8mq-pv100a2g () {
  install -m 0644 ${WORKDIR}/system.conf.imx8mq-pv100a ${D}${sysconfdir}/systemd/system.conf
}
