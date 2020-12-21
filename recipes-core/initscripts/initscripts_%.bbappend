FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"

SRC_URI += "file://rtcinit.sh \
            file://lteinit.sh \
            file://audioinit.sh \
"

do_install_append () {
  install -m 0755 ${WORKDIR}/rtcinit.sh ${D}${sysconfdir}/init.d
  install -m 0755 ${WORKDIR}/lteinit.sh ${D}${sysconfdir}/init.d
  update-rc.d -r ${D} rtcinit.sh start 50 2 3 4 5 .
  update-rc.d -r ${D} lteinit.sh start 51 2 3 4 5 .
}

do_install_append_imx8mq-pv100a() {
  install -m 0755 ${WORKDIR}/audioinit.sh ${D}${sysconfdir}/init.d
  update-rc.d -r ${D} audioinit.sh start 52 2 3 4 5 .
}
