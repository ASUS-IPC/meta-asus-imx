FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

SRC_URI += " \
            file://0002-systemd-logind.conf-modify-and-enable-HoldoffTimeout.patch \
            file://0001-set-the-timeout-of-systemd-network-wait-online-as-20.patch \
"
