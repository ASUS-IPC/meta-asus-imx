FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"

SRC_URI += "file://automount.rules \
            file://mount.blacklist \
            file://mount_fs.sh \
"

do_install_append () {
    install -m 0644 ${WORKDIR}/automount.rules ${D}${sysconfdir}/udev/rules.d/automount.rules
    install -m 0644 ${WORKDIR}/mount.blacklist ${D}${sysconfdir}/udev/
    install -m 0755 ${WORKDIR}/mount_fs.sh ${D}${sysconfdir}/udev/scripts/mount_fs.sh
}
