# Copyright (C) 2014 O.S. Systems Software LTDA.
# Copyright (C) 2014-2016 Freescale Semiconductor
# Copyright 2017-2020 NXP

# require u-boot-asus-imx_${PV}.bb
require u-boot-asus-imx_2020_04.bb
require recipes-bsp/u-boot/u-boot-mfgtool.inc

SPL_IMAGE = "${SPL_BINARYNAME}-${MACHINE}-mfgtool-${PV}-${PR}"
SPL_SYMLINK = "${SPL_BINARYNAME}-mfgtool-${MACHINE}"
