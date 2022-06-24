FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

INI_UNCOMMENT_ASSIGNMENTS_remove = " \
"
do_install_append() {
	sed -i -e "/WatchdogSec/d" ${D}${systemd_system_unitdir}/weston@.service
	sed -i -e "36a WatchdogSec=35" ${D}${systemd_system_unitdir}/weston@.service
	sed -i -e "37a Restart=on-watchdog" ${D}${systemd_system_unitdir}/weston@.service
}