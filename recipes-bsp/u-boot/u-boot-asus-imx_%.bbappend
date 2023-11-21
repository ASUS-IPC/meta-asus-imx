FILES:${PN} += "/etc/*"

SWU_HW_REV ?= "1.0"

addtask deploy after do_install

do_install:append () {
    if [ "${FOTA_ENABLED}" = "ENABLED" ]; then
        echo "/dev/mmcblk0 0x400000 0x2000" > ${D}${sysconfdir}/fw_env.config
        echo "/dev/mmcblk0 0x402000 0x2000" >> ${D}${sysconfdir}/fw_env.config
        echo "${MACHINE} ${SWU_HW_REV}" > ${D}${sysconfdir}/hwrevision
    fi
}

do_deploy:append () {
    if [ "${FOTA_ENABLED}" = "ENABLED" ]; then
        install -D -m 644  ${D}${sysconfdir}/fw_env.config  ${DEPLOYDIR}
        install -D -m 644  ${D}${sysconfdir}/hwrevision  ${DEPLOYDIR}
    fi
}