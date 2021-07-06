FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"

do_install_append_imx8mq-pe100a() {
  rm ${D}${sysconfdir}/systemd/system/getty.target.wants/serial-getty@ttymxc0.service
}

do_install_append_imx8mq-pv100a() {
  rm ${D}${sysconfdir}/systemd/system/getty.target.wants/serial-getty@ttymxc0.service
}

do_install_append_imx8mq-pv100a2g() {
  rm ${D}${sysconfdir}/systemd/system/getty.target.wants/serial-getty@ttymxc0.service
}
