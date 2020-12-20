SUMMARY = "Python Imaging Library (Fork). Pillow is the friendly PIL fork by Alex \
Clark and Contributors. PIL is the Python Imaging Library by Fredrik Lundh and \
Contributors."
HOMEPAGE = "https://pillow.readthedocs.io"
LICENSE = "MIT"
#LIC_FILES_CHKSUM = "file://LICENSE;md5=ea2dc3f5611e69058503d4b940049d03"

#SRC_URI = "git://github.com/python-pillow/Pillow.git;branch=master \
#"
#SRCREV = "57c4be17a93cde09243fe5ca36a5ebb9cc632103"

LIC_FILES_CHKSUM = "file://LICENSE;md5=55c0f320370091249c1755c0d2b48e89"

SRC_URI = "git://github.com/python-pillow/Pillow.git;branch=6.2.x \
           file://0001-support-cross-compiling.patch \
           file://0001-explicitly-set-compile-options.patch \
"
SRCREV ?= "6e0f07bbe38def22d36ee176b2efd9ea74b453a6"

inherit setuptools3

CLEANBROKEN = "1"

DEPENDS += " \
    zlib \
    jpeg \
    tiff \
    freetype \
    lcms \
    openjpeg \
"
RDEPENDS_${PN} += " \
    ${PYTHON_PN}-misc \
    ${PYTHON_PN}-logging \
    ${PYTHON_PN}-numbers \
"

do_configure[noexec] = "1"

CVE_PRODUCT = "pillow"

S = "${WORKDIR}/git"

RPROVIDES_${PN} += "python3-imaging"

BBCLASSEXTEND = "native"
