FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://bdwlan30.bin \
            file://otp30.bin \
            file://qwlan30.bin \
            file://utf30.bin \
            file://qcom_cfg.ini \
            file://COPYING \
"

LIC_FILES_CHKSUM = "file://${WORKDIR}/COPYING;md5=d32239bcb673463ab874e80d47fae504"

do_install_append () {
	install -d ${D}/lib/firmware/qca6174
	install -m 0644 ${WORKDIR}/bdwlan30.bin ${D}/lib/firmware/qca6174
	install -m 0644 ${WORKDIR}/otp30.bin ${D}/lib/firmware/qca6174
	install -m 0644 ${WORKDIR}/qwlan30.bin ${D}/lib/firmware/qca6174
	install -m 0644 ${WORKDIR}/utf30.bin ${D}/lib/firmware/qca6174

	install -d ${D}/lib/firmware/wlan/qca6174
	install -m 0644 ${WORKDIR}/qcom_cfg.ini ${D}/lib/firmware/wlan/qca6174
}
