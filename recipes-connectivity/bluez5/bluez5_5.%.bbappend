FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append += "file://main.conf.patch \
"

do_install_append() {
	install -d ${D}${sysconfdir}/bluetooth/
	if [ -f ${S}/src/main.conf ]; then
		install -m 0644 ${S}/src/main.conf ${D}/${sysconfdir}/bluetooth/
	fi
}
