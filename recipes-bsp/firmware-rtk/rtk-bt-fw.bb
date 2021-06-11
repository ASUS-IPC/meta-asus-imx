SUMMARY = "Realtek Bluetooth firmware"
DESCRIPTION = "Realtek Bluetooth firmware for modules such as RTL8822CE"
SECTION = "base"
LICENSE = "Proprietary"

FILES_${PN} += "/lib/firmware/rtl_bt/rtl8822cu_config.bin /lib/firmware/rtl_bt/rtl8822cu_config.bin"
FILES_${PN} += "/lib/firmware/rtl_bt/rtl8822cu_fw.bin /lib/firmware/rtl_bt/rtl8822cu_fw.bin"
FILES_${PN} += "/lib/firmware/rtl_bt/rtl8822bu_config.bin /lib/firmware/rtl_bt/rtl8822bu_config.bin"
FILES_${PN} += "/lib/firmware/rtl_bt/rtl8822bu_fw.bin /lib/firmware/rtl_bt/rtl8822bu_fw.bin"

SRC_URI = "file://rtl8822cu_config.bin \
           file://rtl8822cu_fw.bin \
           file://rtl8822bu_config.bin \
           file://rtl8822bu_fw.bin \
           file://COPYING \
           "

LIC_FILES_CHKSUM = "file://${WORKDIR}/COPYING;md5=d32239bcb673463ab874e80d47fae504"

do_install () {
    install -d ${D}/lib/firmware/rtl_bt
    install -m 0755 ${WORKDIR}/rtl8822cu_config.bin ${D}/lib/firmware/rtl_bt
    install -m 0755 ${WORKDIR}/rtl8822bu_config.bin ${D}/lib/firmware/rtl_bt
    install -m 0755 ${WORKDIR}/rtl8822cu_fw.bin ${D}/lib/firmware/rtl_bt
    install -m 0755 ${WORKDIR}/rtl8822bu_fw.bin ${D}/lib/firmware/rtl_bt
}
