DESCRIPTION = "MRAA Library Built by ASUS"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://libmraa.so \
"
S = "${WORKDIR}"
do_package_qa[noexec] = "1"
do_compile[noexec] = "1"
#INHIBIT_PACKAGE_STRIP="1"
#INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_SYSROOT_STRIP="1"
#INSANE_SKIP_${PN} = "stripped"

do_install() {
    install -d ${D}${libdir}
    install -m 0755 ${WORKDIR}/libmraa.so ${D}${libdir}
}

FILES_${PN} += "${libdir}/"
FILES_SOLIBSDEV = ""
INSANE_SKIP_${PN} += "dev-so"
