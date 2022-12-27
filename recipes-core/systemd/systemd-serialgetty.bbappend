FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

do_install:append() {
  if [ "${SERIAL_CONSOLES_ENABLE}" = "false" ]; then
    rm ${D}${sysconfdir}/systemd/system/getty.target.wants/serial-getty@ttymxc0.service
  fi
}