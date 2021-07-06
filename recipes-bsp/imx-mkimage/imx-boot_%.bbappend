FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_imx8mq-pv100a2g = " file://0001-imx-mkimage-imx8mq-add-2G-support.patch "

do_compile_prepend () {
	cp ${DEPLOY_DIR_IMAGE}/${BOOT_TOOLS}/${UBOOT_DTB_NAME}   ${S}/${SOC_DIR}/fsl-imx8mq-evk.dtb
}
