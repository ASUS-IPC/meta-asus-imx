FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append += "file://0001-ddr-Don-t-disable-regions-for-4g-ddr.patch"

PLATFORM_FLAVOR_imx8mq-im-a     = "mx8mqevk"
PLATFORM_FLAVOR_imx8mq-pe100a   = "mx8mqevk"
PLATFORM_FLAVOR_imx8mq-pv100a   = "mx8mqevk"
