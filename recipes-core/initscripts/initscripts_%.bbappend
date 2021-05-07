FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"

SRC_URI += "file://rtcinit.sh \
"

do_install_append () {
  install -m 0755 ${WORKDIR}/rtcinit.sh ${D}${sysconfdir}/init.d
  update-rc.d -r ${D} rtcinit.sh start 50 2 3 4 5 .
}

