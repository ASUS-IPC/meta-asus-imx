FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://iotedge.service \
"

do_install_append () {
  install -m 0644 ${WORKDIR}/iotedge.service ${D}${systemd_unitdir}/system
}
