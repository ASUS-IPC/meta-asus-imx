SUMMARY = "Linux CANopen tools"
DESCRIPTION = "Linux CANOpen Protocol Stack Tools"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3b83ef96387f14655fc854ddc3c6bd57"

SRC_URI = "git://github.com/CANopenNode/CANopenSocket.git;protocol=https"
SRCREV = "7b8b45fcd2e2d6fa5a9a55d8f3aa8b54ce81a98b"

S = "${WORKDIR}/git"

INSANE_SKIP_${PN} = "ldflags"

do_compile_prepend() {
    cd ${S}/CANopenNode
    git submodule init
    git submodule update
}

do_compile() {
    cd ${S}/canopend
    make
    cd ${S}/canopencomm
    make
    cd ${S}/canopencgi
    make
}

do_install(){
    install -d ${D}${bindir}
    install -m 0755 ${S}/canopend/app/canopend ${D}${bindir}
    install -m 0755 ${S}/canopencomm/canopencomm ${D}${bindir}
    install -m 0755 ${S}/canopencgi/canopen.cgi ${D}${bindir}
}
