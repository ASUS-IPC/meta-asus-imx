include ${BPN}.inc

SRC_URI += " \
    https://github.com/tpm2-software/${BPN}/releases/download/${PV}/${BPN}-${PV}.tar.gz \
"
SRC_URI[md5sum] = "e67fb1f28b712a415f9ee8d8a430bb16"
SRC_URI[sha256sum] = "044522f1568f3d5334878f0564f808ec9fdd6a4ac5d0f3bd75ae6f2c7551a96c"
