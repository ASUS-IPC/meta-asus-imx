FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append += "${@bb.utils.contains_any('UBOOT_CONFIG', '2G', 'file://0001-imx-mkimage-imx8mq-add-2G-support.patch', '', d)}"

do_compile_prepend () {
  cp ${DEPLOY_DIR_IMAGE}/${BOOT_TOOLS}/${UBOOT_DTB_NAME} ${BOOT_STAGING}/imx8mq-evk.dtb
}
