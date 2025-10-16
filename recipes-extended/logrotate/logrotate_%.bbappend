FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

SRC_URI:append = " \
		file://rsyslog \
		file://logrotate_modify.conf \
		file://logrotate_modify.timer \
            	"
CONFFILES:${PN} += "${sysconfdir}/logrotate.d/rsyslog"

do_install:append(){
    mkdir -p ${D}${sysconfdir}/logrotate.d
    install -p -m 644 ${WORKDIR}/rsyslog ${D}${sysconfdir}/logrotate.d/rsyslog
    install -p -m 644 ${WORKDIR}/logrotate_modify.conf ${D}${sysconfdir}/logrotate.conf
    install -p -m 644 ${WORKDIR}/logrotate_modify.timer  ${D}${systemd_system_unitdir}/logrotate.timer
}
