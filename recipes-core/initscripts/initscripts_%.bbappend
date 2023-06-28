FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

SRC_URI += "file://adbd.sh \
           file://overlayetc \
           file://fotaclient \
"

do_install:append () {
  install -m 0755 ${WORKDIR}/adbd.sh ${D}${sysconfdir}/init.d
  update-rc.d -r ${D} adbd.sh start 40 S . stop 01 6 .

	if [ "${ROOTFS_OVERLAY_ENABLED}" = "ENABLED" ]; then
		install -m 0755 ${WORKDIR}/overlayetc ${D}${sysconfdir}/init.d
	fi

    if [ "${FOTA_ENABLED}" = "ENABLED" ]; then
        install -m 0755 ${WORKDIR}/fotaclient ${D}${sysconfdir}/init.d
    fi
}
