DESCRIPTION = "Init config package"
HOMEPAGE = "https://coral.googlesource.com/edgetpu"
SRC_URI = "file://swig \
           file://edgetpu_runtime_20220308.zip \
	       git://github.com/google-coral/pycoral.git;protocol=https;branch=master "

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
          glibc \
          libgcc \
          libstdc++ \
          libusb1 \
"


MY_INSTALL_ARGS = "--root=${D} \
    --prefix=${prefix} \
    --install-lib=${PYTHON_SITEPACKAGES_DIR} \
"

PYTHON3_SITEPACKAGES_DIR_ARGS = "${libdir}/python3.8/site-packages"


DIRFILES = "1"

inherit setuptools3 python3native 

DEPENDS = "python3 python3-pip-native python3-wheel-native curl"
DEPENDS_class-native = "curl-native"

do_install() {
  ${STAGING_BINDIR_NATIVE}/pip3 install --disable-pip-version-check -v --no-deps \
        -t ${D}/${PYTHON_SITEPACKAGES_DIR} --no-cache-dir ${WORKDIR}/swig/pycoral-2.0.0-cp38-cp38-linux_aarch64.whl
  ${STAGING_BINDIR_NATIVE}/pip3 install --disable-pip-version-check -v --no-deps \
        -t ${D}/${PYTHON_SITEPACKAGES_DIR} --no-cache-dir ${WORKDIR}/swig/tflite_runtime-2.5.0.post1-cp38-cp38-linux_aarch64.whl

  bash ${WORKDIR}/edgetpu_runtime/install.sh
  
  install -d ${D}/${libdir}
  install -m 755 ${WORKDIR}/edgetpu_runtime/libedgetpu/throttled/aarch64/libedgetpu.so.1.0 ${D}/${libdir}/
  lnr ${D}/${libdir}/libedgetpu.so.1.0 ${D}/${libdir}/libedgetpu.so.1
  
  install -d ${D}/${datadir}/pycoral/
  install -d ${D}/${datadir}/pycoral/test_data
  cp -R --no-dereference --preserve=mode,links -v ${S}/examples ${D}/${datadir}/pycoral/
}

FILES_${PN} += "${libdir}/* ${datadir}"
FILES_SOLIBSDEV = ""
INSANE_SKIP_${PN} += "dev-so"
