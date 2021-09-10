SUMMARY = "The TCG TPM2 Software Stack"
DESCRIPTION = "The TCG (Trusted Computing Group) Software Stack (TSS) \
provides a standard API for accessing the functions of the TPM. \
Application developers can use this software to develop interoperable \
client applications."
HOMEPAGE = "https://github.com/tpm2-software/tpm2-tss"
SECTION = "security/tpm"
LICENSE = "BSD-2-Clause"
LIC_FILES_CHKSUM = "file://${S}/LICENSE;md5=0b1d631c4218b72f6b05cb58613606f4"

DEPENDS = "autoconf-archive-native libgcrypt ibmswtpm2 uthash cmocka"

PROVIDES = "${PACKAGES}"

inherit autotools pkgconfig

export CMOCKA_CFLAGS = "-I${WORKDIR}/../../cmocka/1.1.5+gitAUTOINC+546bd50924-r0/image/usr/include"
export CMOCKA_LIBS = "-L${WORKDIR}/../../cmocka/1.1.5+gitAUTOINC+546bd50924-r0/image/usr/lib"

export LIBCRYPTO_CFLAGS = "-I${WORKDIR}/../../openssl/1.1.1g-r0/sysroot-destdir/usr/include"
export LIBCRYPTO_LIBS = "-L${WORKDIR}/../../openssl/1.1.1g-r0/image/usr/lib/"

CFLAGS += " -I${WORKDIR}/../../uthash/2.0.2-r0/image/usr/include \
    -I${WORKDIR}/../../openssl/1.1.1g-r0/openssl-1.0.2p/include \
"
LDFLAGS += "-L${WORKDIR}/../../openssl/1.1.1g-r0/image/usr/lib \
    -L${WORKDIR}/../../openssl/1.1.1g-r0/image/usr/lib  \
    -L${WORKDIR}/../../openssl/1.1.1g-r0/image/usr/lib/ \
    -L${WORKDIR}/../../cmocka/1.1.5+gitAUTOINC+546bd50924-r0/image/usr/lib -lcmocka \
    -lssl -lcrypto \
"

SRC_URI += "\
    file://tpm2-tss.sh \
    file://tpm2-tss.service \
"

LIBS += "-lssl -lcrypto"

PKG_CONFIG += "${WORKDIR}/../../cmocka/1.1.5+gitAUTOINC+546bd50924-r0/build/: \
    ${WORKDIR}/../../openssl/1.1.1g-r0/image/usr/lib/pkgconfig: \
"
PKG_CONFIG_PATH += "${PKG_CONFIG}:"
PKG_CONFIG_LIBDIR += "${PKG_CONFIG}"

EXTRA_OECONF += " \
    --with-udevrulesdir=${sysconfdir}/udev/rules.d \
    --disable-doxygen-doc \
    --enable-unit \
    --enable-debug=yes \
    --with-maxloglevel=trace \
    --with-crypto=ossl \
    --disable-silent-rules \
    --enable-dependency-tracking \
    \
    --disable-tcti-device-async \
    --disable-tcti-partial-reads \
    --with-tctidefaultmodule=libtss2-tcti-device.so \
    --with-tctidefaultconfig=/dev/tpm0 \
"

PACKAGES = " \
    libtss2-mu \
    libtss2-mu-dev \
    libtss2-mu-staticdev \
    libtss2-tcti-device \
    libtss2-tcti-device-dev \
    libtss2-tcti-device-staticdev \
    libtss2-tcti-mssim \
    libtss2-tcti-mssim-dev \
    libtss2-tcti-mssim-staticdev \
    libtss2 \
    libtss2-dev \
    libtss2-staticdev \
    ${PN} \
    ${PN}-doc \
    ${PN}-dbg \
"

FILES_libtss2-tcti-device = "${libdir}/libtss2-tcti-device.so.*"
FILES_libtss2-tcti-device-dev = " \
    ${includedir}/tss2/tss2_tcti_device.h \
    ${libdir}/pkgconfig/tss2-tcti-device.pc \
    ${libdir}/libtss2-tcti-device.so"
FILES_libtss2-tcti-device-staticdev = "${libdir}/libtss2-tcti-device.*a"

FILES_libtss2-tcti-mssim = "${libdir}/libtss2-tcti-mssim.so.*"
FILES_libtss2-tcti-mssim-dev = " \
    ${includedir}/tss2/tss2_tcti_mssim.h \
    ${libdir}/pkgconfig/tss2-tcti-mssim.pc \
    ${libdir}/libtss2-tcti-mssim.so"
FILES_libtss2-tcti-mssim-staticdev = "${libdir}/libtss2-tcti-mssim.*a"

FILES_libtss2-mu = "${libdir}/libtss2-mu.so.*"
FILES_libtss2-mu-dev = " \
    ${includedir}/tss2/tss2_mu.h \
    ${libdir}/pkgconfig/tss2-mu.pc \
    ${libdir}/libtss2-mu.so"
FILES_libtss2-mu-staticdev = "${libdir}/libtss2-mu.*a"

FILES_libtss2 = "${libdir}/libtss2*so.*"
FILES_libtss2-dev = " \
    ${includedir} \
    ${libdir}/pkgconfig \
    ${libdir}/libtss2*so \
    ${libdir}/libtss2-mu.so.*"
FILES_libtss2-staticdev = "${libdir}/libtss*a"

do_qa_staging() {
}

FILES_${PN} += " \
    /usr \
    /usr/lib \
    /lib/ \
    ${sysconfdir} \
    ${sysconfdir}/init.d \             
    ${systemd_system_unitdir} \
"

do_configure_prepend() {
    install -d "${S}/../${BPN}-${PV}"
    cp -pdR "${WORKDIR}/../../../../../../sources/meta-asus-imx/recipes-tpm/tpm2-tss/files/tpm2-tss.sh" "${S}/../${BPN}-${PV}/.."
    cp -pdR "${WORKDIR}/../../../../../../sources/meta-asus-imx/recipes-tpm/tpm2-tss/files/tpm2-tss.service" "${S}/../${BPN}-${PV}/.."
}

do_install_append() {
    install -d "${D}${sysconfdir}/init.d"
    install -m 0755 "${WORKDIR}/tpm2-tss.sh" "${D}${sysconfdir}/init.d"
 
    install -d "${D}${systemd_system_unitdir}"
    install -m 0644 "${WORKDIR}/tpm2-tss.service" "${D}${systemd_system_unitdir}"

    install -d "${D}/etc/systemd/system/multi-user.target.wants"
    (cd ${D}/etc/systemd/system/multi-user.target.wants; \
     ln -s ${systemd_system_unitdir}/tpm2-tss.service tpm2-tss.service; \
    )

    if [ -n "$(ls -A ${WORKDIR}/image/usr/lib)" ]; then
        install -d ${WORKDIR}/../../../../../../sources/meta-asus-imx/recipes-bsp/asus-overlay/files/imx8mq-im-a/usr/lib
        cp -pdR ${WORKDIR}/image/usr/lib/lib*.so* ${WORKDIR}/../../../../../../sources/meta-asus-imx/recipes-bsp/asus-overlay/files/imx8mq-im-a/usr/lib
        install -d ${WORKDIR}/../../../../../../sources/meta-asus-imx/recipes-bsp/asus-overlay/files/imx8mq-pv100a/usr/lib
        cp -pdR ${WORKDIR}/image/usr/lib/lib*.so* ${WORKDIR}/../../../../../../sources/meta-asus-imx/recipes-bsp/asus-overlay/files/imx8mq-pv100a/usr/lib
        install -d ${WORKDIR}/../../../../../../sources/meta-asus-imx/recipes-bsp/asus-overlay/files/imx8mq-pe100a/usr/lib
        cp -pdR ${WORKDIR}/image/usr/lib/lib*.so* ${WORKDIR}/../../../../../../sources/meta-asus-imx/recipes-bsp/asus-overlay/files/imx8mq-pe100a/usr/lib
    fi
}

SYSTEMD_SERVICE_${PN} = "tpm2-tss.service"
SYSTEMD_AUTO_ENABLE = "enable"
pkg_postinst_${PN} () {
    OPTS=""

    if [ x"$D" != "x" ]; then
        OPTS="--root=$D"
        if type systemctl >/dev/null 2>/dev/null; then
                systemctl $OPTS ${SYSTEMD_AUTO_ENABLE} ${SYSTEMD_SERVICE}
        fi
        exit 1
    fi
}
