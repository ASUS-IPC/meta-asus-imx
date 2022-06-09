FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://otp30.bin \
            file://qwlan30.bin \
            file://utf30.bin \
            file://qcom_cfg.ini \
            file://bdwlan30.bin_aw-cb260nf \
            file://bdwlan30.bin_jww6051 \
            file://COPYING \
"

do_install_append () {
	install -d ${D}/lib/firmware/qca6174
	install -m 0644 ${WORKDIR}/bdwlan30.bin_aw-cb260nf ${D}/lib/firmware/qca6174
	install -m 0644 ${WORKDIR}/bdwlan30.bin_jww6051 ${D}/lib/firmware/qca6174
	ln -sf ${root_prefix}/lib/firmware/qca6174/bdwlan30.bin_jww6051 ${D}${root_prefix}/lib/firmware/qca6174/bdwlan30.bin

	install -m 0644 ${WORKDIR}/otp30.bin ${D}/lib/firmware/qca6174
	install -m 0644 ${WORKDIR}/qwlan30.bin ${D}/lib/firmware/qca6174
	install -m 0644 ${WORKDIR}/utf30.bin ${D}/lib/firmware/qca6174

	install -d ${D}/lib/firmware/wlan/qca6174
	install -m 0644 ${WORKDIR}/qcom_cfg.ini ${D}/lib/firmware/wlan/qca6174
}
