SUMMARY = "Intel AX200 BT/Wi-Fi firmware"
DESCRIPTION = "Intel AX200 firmware for BT/Wi-Fi function"
SECTION = "base"
LICENSE = "Proprietary"

SRC_URI = "file://wifi \
           file://bt \
           file://COPYING \
           "

LIC_FILES_CHKSUM = "file://${WORKDIR}/COPYING;md5=d32239bcb673463ab874e80d47fae504"

do_install () {
    install -d ${D}/lib/firmware/intel
    install -m 0755 ${WORKDIR}/wifi/* ${D}/lib/firmware/
    install -m 0755 ${WORKDIR}/bt/* ${D}/lib/firmware/intel/
}

FILES_${PN} += "/lib/firmware/*.ucode /lib/firmware/intel/ibt-20-* "
