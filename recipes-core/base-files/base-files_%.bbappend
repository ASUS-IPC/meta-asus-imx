FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

SRC_URI += "file://fstab.root_ro \
           "

do_install:append () {
	if [ "${ROOTFS_OVERLAY_ENABLED}" = "ENABLED" ]; then
		install -m 644 ${S}/fstab.root_ro ${D}/${sysconfdir}/fstab
	fi
}
