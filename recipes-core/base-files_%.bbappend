FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

SRC_URI += "file://fstab.root_ro \
           "

do_install:append () {
  install -m 644 ${S}/fstab.root_ro ${D}/${sysconfdir}/fstab
}
