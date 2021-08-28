SUMMARY = "TPM2 Tools Install tpm2-tss"
DESCRIPTION = "TPM2 Tools Install"
SRC_URI = ""
SECTION = "security/tpm"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://${S}/LICENSE;md5=6242a9b7e649acd850feeb4cd4cf71bd"

#INSANE_SKIP_${PN} = "stripped"
#INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
#INHIBIT_PACKAGE_STRIP = "1"
#
#do_package_qa[noexec] = "1"

inherit autotools pkgconfig

PROVIDES = "${PACKAGES}"

do_install() {

    install -d ${D}/usr/lib
    cp -pdR ${WORKDIR}/../../tpm2-tss/3.0.0-r0/sysroot-destdir/usr/lib/libtss2-esys.so ${D}/usr/lib
    cp -pdR ${WORKDIR}/../../tpm2-tss/3.0.0-r0/sysroot-destdir/usr/lib/libtss2-mu.so ${D}/usr/lib
    cp -pdR ${WORKDIR}/../../tpm2-tss/3.0.0-r0/sysroot-destdir/usr/lib/libtss2-rc.so ${D}/usr/lib
    cp -pdR ${WORKDIR}/../../tpm2-tss/3.0.0-r0/sysroot-destdir/usr/lib/libtss2-sys.so ${D}/usr/lib
    cp -pdR ${WORKDIR}/../../tpm2-tss/3.0.0-r0/sysroot-destdir/usr/lib/libtss2-tcti-default.so ${D}/usr/lib
    cp -pdR ${WORKDIR}/../../tpm2-tss/3.0.0-r0/sysroot-destdir/usr/lib/libtss2-tcti-device.so ${D}/usr/lib
    cp -pdR ${WORKDIR}/../../tpm2-tss/3.0.0-r0/sysroot-destdir/usr/lib/libtss2-tctildr.so ${D}/usr/lib
    cp -pdR ${WORKDIR}/../../tpm2-tss/3.0.0-r0/sysroot-destdir/usr/lib/libtss2-tcti-mssim.so ${D}/usr/lib
    
}

FILES_${PN} += ""


FILES_${PN} += " \
    /Test_tool \
    /usr \
    /usr/lib \
    /lib/ \
    ${sysconfdir} \
    ${sysconfdir}/init.d \             
    ${systemd_system_unitdir} \
"
