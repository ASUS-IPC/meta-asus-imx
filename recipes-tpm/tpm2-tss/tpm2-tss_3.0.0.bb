include ${BPN}.inc

LIC_FILES_CHKSUM = "file://${S}/LICENSE;md5=500b2e742befc3da00684d8a1d5fd9da"
SRC_URI = "https://github.com/tpm2-software/${BPN}/releases/download/${PV}/${BPN}-${PV}.tar.gz"

SRC_URI[md5sum] = "a075c9f0e1e94d059c9d8b44803fa599"
SRC_URI[sha256sum] = "4871db4f54b90f9619e79589584bd72f8101f8dad402e7d4bafb14181e0517ac"

S = "${WORKDIR}/${BPN}-${PV}"
