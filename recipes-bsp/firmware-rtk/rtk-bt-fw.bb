SUMMARY = "Realtek Bluetooth firmware"
DESCRIPTION = "Realtek Bluetooth firmware for modules such as RTL8822CE"
SECTION = "base"
LICENSE = "Proprietary"

FILES_${PN} += "/lib/firmware/rtl8822cu_config /lib/firmware/rtl8822cu_config"
FILES_${PN} += "/lib/firmware/rtl8822cu_fw /lib/firmware/rtl8822cu_fw"
FILES_${PN} += "/lib/firmware/rtl8822bu_config /lib/firmware/rtl8822bu_config"
FILES_${PN} += "/lib/firmware/rtl8822bu_fw /lib/firmware/rtl8822bu_fw"

SRC_URI = "file://rtl8822cu_config \
           file://rtl8822cu_fw \
           file://rtl8822bu_config \
           file://rtl8822bu_fw \
           file://COPYING \
           "

LIC_FILES_CHKSUM = "file://${WORKDIR}/COPYING;md5=d32239bcb673463ab874e80d47fae504"

do_install () {
    install -d ${D}/lib/firmware
    install -m 0755 ${WORKDIR}/rtl8822cu_config ${D}/lib/firmware
    install -m 0755 ${WORKDIR}/rtl8822bu_config ${D}/lib/firmware
    install -m 0755 ${WORKDIR}/rtl8822cu_fw ${D}/lib/firmware
    install -m 0755 ${WORKDIR}/rtl8822bu_fw ${D}/lib/firmware
}
