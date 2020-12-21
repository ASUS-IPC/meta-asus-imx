SUMMARY = "Qualcomm QCA6174A Bluetooth USB firmware"
DESCRIPTION = "Qualcomm Bluetooth firmware for Azure AW-CB260NF"
SECTION = "base"
LICENSE = "Proprietary"

FILES_${PN} += "/lib/firmware/qca/nvm_usb_00000302.bin /lib/firmware/qca/nvm_usb_00000302.bin"
FILES_${PN} += "/lib/firmware/qca/rampatch_usb_00000302.bin /lib/firmware/qca/rampatch_usb_00000302.bin"

SRC_URI = "file://nvm_usb_00000302.bin \
           file://rampatch_usb_00000302.bin \
           file://COPYING \
           "

LIC_FILES_CHKSUM = "file://${WORKDIR}/COPYING;md5=d32239bcb673463ab874e80d47fae504"

do_install () {
    install -d ${D}/lib/firmware/qca
    install -m 0755 ${WORKDIR}/nvm_usb_00000302.bin ${D}/lib/firmware/qca
    install -m 0755 ${WORKDIR}/rampatch_usb_00000302.bin ${D}/lib/firmware/qca
}
