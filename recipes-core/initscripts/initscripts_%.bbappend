FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

SRC_URI += "file://adbd.sh \
"

do_install:append () {
  install -m 0755 ${WORKDIR}/adbd.sh ${D}${sysconfdir}/init.d
  update-rc.d -r ${D} adbd.sh start 40 S . stop 01 6 .
}
