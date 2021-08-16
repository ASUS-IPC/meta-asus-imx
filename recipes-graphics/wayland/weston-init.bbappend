FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"

SRC_URI += "file://weston.service \
"

do_install_append () {
  install -m 0644 ${WORKDIR}/weston.service ${D}${base_libdir}/systemd/system
}
