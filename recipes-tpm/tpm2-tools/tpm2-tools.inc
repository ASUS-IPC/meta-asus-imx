SUMMARY = "Tools for TPM2"
DESCRIPTION = "This project builds a set of command-line tools for \
interacting with a TPM (Trusted Platform Module) 2."
HOMEPAGE = "https://github.com/tpm2-software/tpm2-tools"
SECTION = "security/tpm"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://${S}/LICENSE;md5=0eb1216e46938bd723098d93a23c3bcc"

DEPENDS = " \
    tpm2-abrmd openssl curl autoconf-archive-native \
    tpm2-tss libtss2 libtss2-mu libtss2-tcti-device libtss2-tcti-mssim \
    python python-pyyaml glibc autoconf libtool automake libtool \
    "

inherit autotools pkgconfig

# SYSTEMD_PACKAGES += "${PN}"
# SYSTEMD_SERVICE_${PN} = "tpm2-abrmd.service"
# SYSTEMD_AUTO_ENABLE_${PN} = "enable"
# 
# INITSCRIPT_NAME = "${PN}"
# INITSCRIPT_PARAMS = "start 99 2 3 4 5 . stop 19 0 1 6 ."
# 
# USERADD_PACKAGES = "${PN}"
# GROUPADD_PARAM_${PN} = "tss"
# USERADD_PARAM_${PN} = "--system -M -d /var/lib/tpm -s /bin/false -g tss tss"

EXTRA_CFLAGS += "-I${WORKDIR}/../../tpm2-abrmd/2.4.0-r0/image/usr/include -ltss2-tcti-tabrmd"
EXTRA_LIBS += "${WORKDIR}/../../tpm2-abrmd/2.4.0-r0/image/usr/lib/libtss2-tcti-tabrmd.so"

CMOCKA_CFLAGS += "-I${WORKDIR}/../../cmocka/1.1.5+gitAUTOINC+546bd50924-r0/image/usr/include -lcmocka"
CMOCKA_LIBS += "${WORKDIR}/../../cmocka/1.1.5+gitAUTOINC+546bd50924-r0/image/usr/lib/libcmocka.so"

TSS2_TCTILDR_CFLAGS += "-I${WORKDIR}/../../tpm2-tss/3.0.0-r0/image/usr/include"
TSS2_TCTILDR_LIBS += "${WORKDIR}/../../tpm2-tss/3.0.0-r0/sysroot-destdir/usr/lib/libtss2-tcti-mssim.so \
    ${WORKDIR}/../../tpm2-tss/3.0.0-r0/sysroot-destdir/usr/lib/libtss2-tcti-device.so \
    ${WORKDIR}/../../tpm2-abrmd/2.4.0-r0/sysroot-destdir/usr/lib/libtss2-tcti-tabrmd.so \
    ${WORKDIR}/../../tpm2-tss/3.0.0-r0/sysroot-destdir/usr/lib/libtss2-esys.so \
    ${WORKDIR}/../../tpm2-tss/3.0.0-r0/sysroot-destdir/usr/lib/libtss2-tctildr.so \
    ${WORKDIR}/../../tpm2-tss/3.0.0-r0/sysroot-destdir/usr/lib/libtss2-tcti-cmd.so \
    ${WORKDIR}/../../tpm2-tss/3.0.0-r0/sysroot-destdir/usr/lib/libtss2-tcti-swtpm.so \
"

export CRYPTO_CFLAGS += "-I${WORKDIR}/../../openssl/1.1.1g-r0/sysroot-destdir/usr/include"
CRYPTO_LIBS += "-L${WORKDIR}/../../openssl/1.1.1g-r0/image/usr/lib/"

CFLAGS += " -I${WORKDIR}/../../uthash/2.0.2-r0/image/usr/include \
    -I${WORKDIR}/../../openssl/1.1.1g-r0/openssl-1.1.1g/include \
"
CPPFLAGS += "-L${WORKDIR}/../../cmocka/1.1.5+gitAUTOINC+546bd50924-r0/image/usr/lib -lcmocka"

LDFLAGS += "-L${WORKDIR}/../../openssl/1.1.1g-r0/image/usr/lib/ \
    -L${WORKDIR}/../../tpm2-tss/3.0.0-r0/image/usr/lib -ltss2-tctildr -ltss2-tcti-mssim -ltss2-tcti-device -ltss2-tcti-tabrmd \
    ${WORKDIR}/../../tpm2-tss/3.0.0-r0/sysroot-destdir/usr/lib/libtss2-tcti-mssim.so \
    ${WORKDIR}/../../tpm2-tss/3.0.0-r0/sysroot-destdir/usr/lib/libtss2-tcti-device.so \
    ${WORKDIR}/../../tpm2-abrmd/2.4.0-r0/sysroot-destdir/usr/lib/libtss2-tcti-tabrmd.so \
    ${WORKDIR}/../../tpm2-tss/3.0.0-r0/sysroot-destdir/usr/lib/libtss2-esys.so \
    ${WORKDIR}/../../tpm2-tss/3.0.0-r0/sysroot-destdir/usr/lib/libtss2-tctildr.so \
    ${WORKDIR}/../../tpm2-tss/3.0.0-r0/sysroot-destdir/usr/lib/libtss2-tcti-cmd.so \
    ${WORKDIR}/../../tpm2-tss/3.0.0-r0/sysroot-destdir/usr/lib/libtss2-tcti-swtpm.so \
"

LIBS += "${WORKDIR}/../../openssl/1.1.1g-r0/image/usr/lib/libssl.a -lssl \
    ${WORKDIR}/../../openssl/1.1.1g-r0/image/usr/lib/libcryto.a -lcrypto  \
    -L${WORKDIR}/../../openssl/1.1.1g-r0/image/usr/lib/ \
    -L${WORKDIR}/../../cmocka/1.1.5+gitAUTOINC+546bd50924-r0/image/usr/lib -lcmocka \
    ${WORKDIR}/../../tpm2-tss/3.0.0-r0/sysroot-destdir/usr/lib/libtss2-tcti-mssim.so \
    ${WORKDIR}/../../tpm2-tss/3.0.0-r0/sysroot-destdir/usr/lib/libtss2-tcti-device.so \
    ${WORKDIR}/../../tpm2-abrmd/2.4.0-r0/sysroot-destdir/usr/lib/libtss2-tcti-tabrmd.so \
    ${WORKDIR}/../../tpm2-tss/3.0.0-r0/sysroot-destdir/usr/lib/libtss2-esys.so \
    ${WORKDIR}/../../tpm2-tss/3.0.0-r0/sysroot-destdir/usr/lib/libtss2-tctildr.so \
    ${WORKDIR}/../../tpm2-tss/3.0.0-r0/sysroot-destdir/usr/lib/libtss2-tcti-cmd.so \
    ${WORKDIR}/../../tpm2-tss/3.0.0-r0/sysroot-destdir/usr/lib/libtss2-tcti-swtpm.so \
"


PKG_CONFIG += "${WORKDIR}/../../cmocka/1.1.5+gitAUTOINC+546bd50924-r0/build/: \
    ${WORKDIR}/../../openssl/1.1.1g-r0/image/usr/lib/pkgconfig: \
    ${WORKDIR}/../../tpm2-abrmd/2.4.0-r0/image/usr/lib/pkgconfig: \
"
PKG_CONFIG_PATH += "${PKG_CONFIG}:"
PKG_CONFIG_LIBDIR += "${PKG_CONFIG}"


EXTRA_OECONF += " \
    --enable-unit=no \
    --disable-silent-rules \
    --enable-debug=yes \
    --disable-hardening \
    --enable-static=yes \
    --prefix=/usr \
"

FILES_${PN} += "usr/*"
FILES_${PN} += "${WORKDIR}/../../../../../../sources/meta-asus/recipes-tpm/tpm2-tools/tpm2-tools-1.0/tpm2_test.sh "
FILES_${PN} += "${WORKDIR}/../../tpm2-tss/3.0.0-r0/sysroot-destdir/usr/lib/lib*"

RDEPENDS_${PN} += "tpm2-tss"

do_install_prepend() {
  install -d ${WORKDIR}/sysroot-destdir/usr/lib
  cp -rf ${WORKDIR}/../../tpm2-tss/3.0.0-r0/sysroot-destdir/usr/lib/lib* ${WORKDIR}/sysroot-destdir/usr/lib
}
