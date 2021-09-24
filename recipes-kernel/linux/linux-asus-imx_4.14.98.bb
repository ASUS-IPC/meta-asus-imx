# Copyright (C) 2013-2016 Freescale Semiconductor
# Copyright 2017-2018 NXP
# Released under the MIT license (see COPYING.MIT for the terms)

SUMMARY = "Linux Kernel provided and supported by ASUS"
DESCRIPTION = "Linux kernel provided and supported by ASUS \
(based on the kernel provided by NXP) with focus on i.MX Family SOMs. \
It includes support for many IPs such as GPU, VPU and IPU."

require recipes-kernel/linux/linux-imx.inc

DEPENDS += "lzop-native bc-native"

DEFAULT_PREFERENCE = "1"

SRCBRANCH = "yocto-sumo-imx_8m"
LOCALVERSION = "-imx8mq"
KERNEL_SRC = "git://github.com/ASUS-IPC/linux-imx.git;protocol=https"
SRC_URI = "${KERNEL_SRC};branch=${SRCBRANCH}"
SRCREV = "${AUTOREV}"

S = "${WORKDIR}/git"

addtask copy_defconfig after do_unpack before do_preconfigure

IMX_KERNEL_CONFIG_AARCH64 = "defconfig"
IMX_KERNEL_CONFIG_AARCH64_imx8mq-im-a = "ima_defconfig"
IMX_KERNEL_CONFIG_AARCH64_imx8mq-pe100a = "pe100a_defconfig"
IMX_KERNEL_CONFIG_AARCH64_imx8mq-pe100a2g = "pe100a_defconfig"
IMX_KERNEL_CONFIG_AARCH64_imx8mq-pv100a = "pv100a_defconfig"
IMX_KERNEL_CONFIG_AARCH64_imx8mq-pv100a2g = "pv100a_defconfig"


do_copy_defconfig () {
    install -d ${B}
    # copy latest defconfig to use for mx8
    mkdir -p ${B}
    cp ${S}/arch/arm64/configs/${IMX_KERNEL_CONFIG_AARCH64} ${B}/.config
    cp ${S}/arch/arm64/configs/${IMX_KERNEL_CONFIG_AARCH64} ${B}/../defconfig
}

COMPATIBLE_MACHINE = "(mx8)"
