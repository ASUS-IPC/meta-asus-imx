DESCRIPTION = "\
cmocka is an elegant unit testing framework for C with support for mock \
objects. It only requires the standard C library, works on a range of computing \
platforms (including embedded) and with different compilers."

LICENSE = "Apache-2.0"

LIC_FILES_CHKSUM = "file://COPYING;md5=3b83ef96387f14655fc854ddc3c6bd57"

SRC_URI = "git://git.cryptomilk.org/projects/cmocka.git"

SRCREV = "546bd50924245f4ca7292a3ef6a92504aa375455"

PV = "1.1.5+git${SRCPV}"

S = "${WORKDIR}/git"

inherit pkgconfig cmake