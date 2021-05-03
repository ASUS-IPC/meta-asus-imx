FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
	file://soc.mak.imx8mq-im-a \
	file://soc.mak.imx8mq-pe100a \
	file://soc.mak.imx8mq-pv100a \
"

do_compile_prepend_imx8mq-im-a () {
	echo "Copying soc.mak"
	cp ${WORKDIR}/soc.mak.imx8mq-im-a ${S}/iMX8M/soc.mak
}

do_compile_prepend_imx8mq-pe100a () {
	echo "Copying soc.mak"
	cp ${WORKDIR}/soc.mak.imx8mq-pe100a ${S}/iMX8M/soc.mak
}

do_compile_prepend_imx8mq-pv100a () {
	echo "Copying soc.mak"
	cp ${WORKDIR}/soc.mak.imx8mq-pv100a ${S}/iMX8M/soc.mak
}
