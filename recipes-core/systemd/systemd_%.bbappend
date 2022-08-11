FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"

SRC_URI += "file://40-wifi-pm.sh \
"
do_install_append () {
  install -m 0755 ${WORKDIR}/40-wifi-pm.sh ${D}${base_libdir}/systemd/system-sleep
}
