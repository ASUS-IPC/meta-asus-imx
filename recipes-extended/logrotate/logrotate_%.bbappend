FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

SRC_URI:append = " \
		file://0001-rotate-the-log-file.patch  \
            	"
CONFFILES:${PN} += "${sysconfdir}/logrotate.d/rsyslog"

do_install:append(){
    mkdir -p ${D}${sysconfdir}/logrotate.d
    install -p -m 644 ${S}/examples/rsyslog ${D}${sysconfdir}/logrotate.d/rsyslog
}
