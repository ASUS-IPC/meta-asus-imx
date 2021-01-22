FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"

SRC_URI += "file://system.conf \
            file://logind.conf \
            file://reboot.target \
            file://poweroff.target \
            file://systemd-reboot.service \
            file://systemd-poweroff.service \
"

do_install_append () {
  install -m 0644 ${WORKDIR}/system.conf ${D}${sysconfdir}/systemd
  install -m 0644 ${WORKDIR}/logind.conf ${D}${sysconfdir}/systemd
  install -m 0644 ${WORKDIR}/reboot.target ${D}${base_libdir}/systemd/system
  install -m 0644 ${WORKDIR}/poweroff.target ${D}${base_libdir}/systemd/system
  install -m 0644 ${WORKDIR}/systemd-reboot.service ${D}${base_libdir}/systemd/system
  install -m 0644 ${WORKDIR}/systemd-poweroff.service ${D}${base_libdir}/systemd/system
}
