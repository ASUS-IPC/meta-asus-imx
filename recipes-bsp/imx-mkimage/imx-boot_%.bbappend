FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append += "${@bb.utils.contains_any('UBOOT_CONFIG', '2G', 'file://0001-imx-mkimage-imx8mq-add-2G-support.patch', '', d)}"
SRC_URI_append_mx8mq += "${@bb.utils.contains_any('UBOOT_CONFIG', '4G', 'file://0001-imx-mkimage-imx8mq-add-4G-support.patch', '', d)}"

# SRC_URI_append_mx8mp += "${@bb.utils.contains_any('UBOOT_CONFIG', '4G', 'file://0001-imx-mkimage-imx8mp-add-4G-support.patch', '', d)}"

do_compile_prepend_mx8mq () {
    cp ${DEPLOY_DIR_IMAGE}/${BOOT_TOOLS}/${UBOOT_DTB_NAME} ${BOOT_STAGING}/imx8mq-evk.dtb
}

do_compile_prepend_mx8mp () {
    cp ${DEPLOY_DIR_IMAGE}/${BOOT_TOOLS}/${UBOOT_DTB_NAME} ${BOOT_STAGING}/imx8mp-evk.dtb
}

# do_compile_prepend__imx8mq-blizzard () {
#     cp ${DEPLOY_DIR_IMAGE}/${BOOT_TOOLS}/${UBOOT_DTB_NAME} ${BOOT_STAGING}/imx8mp-evk.dtb
# }