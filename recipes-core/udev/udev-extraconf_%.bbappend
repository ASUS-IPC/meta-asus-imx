

do_install:append() {
    if [ "${FOTA_ENABLED}" = "ENABLED" ]; then
        install -d ${D}${sysconfdir}/udev/mount.ignorelist.d
        echo "/dev/mmcblk0" > ${WORKDIR}/emmc.ignorelist
        install -m 0644 ${WORKDIR}/emmc.ignorelist ${D}${sysconfdir}/udev/mount.ignorelist.d
    fi
}
