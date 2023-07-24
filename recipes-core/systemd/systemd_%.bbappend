FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

SRC_URI += " \
            file://0002-systemd-logind.conf-modify-and-enable-HoldoffTimeout.patch \
"
