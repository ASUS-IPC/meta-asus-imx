FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

SRC_URI += "file://default_blizzard.pa"

do_install:append:imx8mp-blizzard2g () {
  install -m 0755 ${WORKDIR}/default_blizzard.pa ${D}${sysconfdir}/pulse/default.pa
}
