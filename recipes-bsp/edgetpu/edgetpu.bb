DESCRIPTION = "Init config package"
HOMEPAGE = "https://coral.googlesource.com/edgetpu"
SRC_URI = "file://libedgetpu/edgetpu-accelerator.rules \
           file://libedgetpu.so.1.0 \
	   file://swig \
	   git://github.com/google-coral/edgetpu.git;protocol=https;branch=master "

SRCREV ?= "${AUTOREV}"
LICENSE = "GPLv2"
PR = "r2"
PV = "1.0+git${SRCPV}"
do_package_qa[noexec] = "1"
LIC_FILES_CHKSUM = "file://LICENSE;md5=d8927f3331d2b3e321b7dd1925166d25 \
"

S = "${WORKDIR}/git"
do_compile[noexec] = "1"
INSANE_SKIP_${PN} = "stripped"
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"

RDEPENDS_${PN} = "python3 \
                  python3-pip \
		  python3-pillow \
		  python3-numpy \
"


MY_INSTALL_ARGS = "--root=${D} \
    --prefix=${prefix} \
    --install-lib=${PYTHON_SITEPACKAGES_DIR} \
"

PYTHON3_SITEPACKAGES_DIR_ARGS = "${libdir}/python3.5/site-packages"


DIRFILES = "1"

inherit setuptools3

do_install() {
  ${STAGING_BINDIR_NATIVE}/python3-native/python3 ${S}/setup.py develop --no-deps
  install -d ${D}${PYTHON3_SITEPACKAGES_DIR_ARGS}/
  install -d ${D}${PYTHON3_SITEPACKAGES_DIR_ARGS}/edgetpu
  cp -R --no-dereference --preserve=mode,links -v ${S}/edgetpu \
  ${D}${libdir}/python3.5/site-packages/
  cp -R --no-dereference --preserve=mode,links -v ${WORKDIR}/swig \
  ${D}${libdir}/python3.5/site-packages/edgetpu
  touch ${D}${PYTHON3_SITEPACKAGES_DIR_ARGS}/easy-install.pth
  echo "./edgetpu" > ${D}${PYTHON3_SITEPACKAGES_DIR_ARGS}/easy-install.pth

  install -d ${D}/${libdir}
  install -m 755 ${WORKDIR}/libedgetpu.so.1.0 ${D}/${libdir}/
  ln -sf ${D}/${libdir}/libedgetpu.so.1.0 ${D}/${libdir}/libedgetpu.so.1

  install -d ${D}${sysconfdir}/udev/rules.d
  install -m 0644 ${WORKDIR}/libedgetpu/edgetpu-accelerator.rules \
                  ${D}${sysconfdir}/udev/rules.d/99-edgetpu-accelerator.rules

  install -d ${D}/${datadir}/edgetpu/examples/
  install -d ${D}/${datadir}/edgetpu/examples/models
  install -d ${D}/${datadir}/edgetpu/examples/images

  cp -R --no-dereference --preserve=mode,links -v ${S}/test_data/*.jpg \
        ${D}/${datadir}/edgetpu/examples/images

  cp -R --no-dereference --preserve=mode,links -v ${S}/test_data/*_edgetpu.tflite \
        ${D}/${datadir}/edgetpu/examples/models

  cp -R --no-dereference --preserve=mode,links -v ${S}/test_data/*.txt \
        ${D}/${datadir}/edgetpu/examples/models

  cp -R --no-dereference --preserve=mode,links -v ${S}/examples/*  ${D}/${datadir}/edgetpu/examples/
}

FILES_${PN} += "${libdir}/"
FILES_SOLIBSDEV = ""
INSANE_SKIP_${PN} += "dev-so"
