FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"

SRC_URI += "file://0001-rotate-the-log-file.patch  \
            "
CONFFILES_${PN} += "${sysconfdir}/logrotate.d/rsyslog"

do_install_append(){
    mkdir -p ${D}${sysconfdir}/logrotate.d
    install -p -m 644 ${S}/examples/rsyslog ${D}${sysconfdir}/logrotate.d/rsyslog
}
