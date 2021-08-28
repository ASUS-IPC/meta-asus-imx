SUMMARY = "TPM2 Access Broker & Resource Manager"
DESCRIPTION = "This is a system daemon implementing the TPM2 Access Broker (AB) \
and Resource Manager (RM) specification from the TCG (Trusted Computing Group). \
The daemon (tpm2-abrmd) is implemented using Glib and the GObject system."
HOMEPAGE = "https://github.com/tpm2-software/tpm2-abrmd"
SECTION = "security/tpm"
LICENSE = "BSD-2-Clause"
LIC_FILES_CHKSUM = "file://${S}/LICENSE;md5=500b2e742befc3da00684d8a1d5fd9da"

DEPENDS += " \
    autoconf-archive-native dbus glib-2.0 glib-2.0-native \
    tpm2-tss libtss2 libtss2-mu libtss2-tcti-device libtss2-tcti-mssim \
    "

SRC_URI = "\
    file://tpm2-abrmd-init.sh \
    file://tpm2-abrmd.default \
"

inherit autotools pkgconfig systemd update-rc.d useradd

SYSTEMD_PACKAGES += "${PN}"
SYSTEMD_SERVICE_${PN} = "tpm2-abrmd.service"
SYSTEMD_AUTO_ENABLE_${PN} = "enable"

INITSCRIPT_NAME = "${PN}"
INITSCRIPT_PARAMS = "start 99 2 3 4 5 . stop 19 0 1 6 ."

USERADD_PACKAGES = "${PN}"
GROUPADD_PARAM_${PN} = "tss"
USERADD_PARAM_${PN} = "--system -M -d /var/lib/tpm -s /bin/false -g tss tss"

export CMOCKA_CFLAGS += "-I${WORKDIR}/../../cmocka/1.1.5+gitAUTOINC+546bd50924-r0/image/usr/include"
export CMOCKA_LIBS += "-L${WORKDIR}/../../cmocka/1.1.5+gitAUTOINC+546bd50924-r0/image/usr/lib"

export TSS2_TCTILDR_CFLAGS += "-I${WORKDIR}/../../tpm2-tss/3.0.0-r0/image/usr/include"
export TSS2_TCTILDR_LIBS += "-L${WORKDIR}/../../tpm2-tss/3.0.0-r0/image/usr/lib"

CRYPTO_CFLAGS += "-I${WORKDIR}/../../openssl/1.1.1g-r0/sysroot-destdir/usr/include"
CRYPTO_LIBS += "-L${WORKDIR}/../../openssl/1.1.1g-r0/image/usr/lib/"

CFLAGS += " -I${WORKDIR}/../../uthash/2.0.2-r0/image/usr/include \
    -I${WORKDIR}/../../openssl/1.1.1g-r0/openssl-1.1.1g/include \
    -I${WORKDIR}/../../cmocka/1.1.5+gitAUTOINC+546bd50924-r0/image/usr/include \
"

LDFLAGS += "-L${WORKDIR}/../../openssl/1.1.1g-r0/image/usr/lib/ \
    -L${WORKDIR}/../../tpm2-tss/3.0.0-r0/image/usr/lib -ltss2-tctildr \
"

LIBS += "${WORKDIR}/../../openssl/1.1.1g-r0/image/usr/lib/libssl.a -lssl \
    ${WORKDIR}/../../openssl/1.1.1g-r0/image/usr/lib/libcryto.a -lcryto  \
    -L${WORKDIR}/../../openssl/1.1.1g-r0/image/usr/lib/ \
"

PKG_CONFIG += "${WORKDIR}/../../cmocka/1.1.5+gitAUTOINC+546bd50924-r0/build/: \
    ${WORKDIR}/../../openssl/1.1.1g-r0/image/usr/lib/pkgconfig: \
    ${WORKDIR}/../../tpm2-tss/3.0.0-r0/image/usr/lib/pkgconfig: \
"
PKG_CONFIG_PATH += "${PKG_CONFIG}:"
PKG_CONFIG_LIBDIR += "${PKG_CONFIG}"

EXTRA_OECONF += "\
    --with-systemdsystemunitdir=${systemd_system_unitdir} \
    --with-systemdpresetdir=${systemd_unitdir}/system-preset \
    --enable-unit \
    --enable-test-hwtpm \
    --enable-integration \
    --disable-silent-rules \
"

do_install_append() {
    install -d "${D}${sysconfdir}/init.d"
    install -m 0755 "${WORKDIR}/tpm2-abrmd-init.sh" "${D}${sysconfdir}/init.d/tpm2-abrmd"

    install -d "${D}${sysconfdir}/default"
    install -m 0644 "${WORKDIR}/tpm2-abrmd.default" "${D}${sysconfdir}/default/tpm2-abrmd"
}

FILES_${PN} += "\
    ${systemd_unitdir}/system-preset \
    ${datadir}/dbus-1/system-services/com.intel.tss2.Tabrmd.service \
"

RDEPENDS_${PN} += "tpm2-tss"
