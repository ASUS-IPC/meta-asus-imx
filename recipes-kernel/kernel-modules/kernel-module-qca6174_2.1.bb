require kernel-module-qcacld-lea.inc

SUMMARY = "Qualcomm WiFi driver for QCA module 6174"

SRC_URI += "file://0001-QCA6174-disable-P2P-WFD.patch \
            file://0002-LEA3.0-CORE-porting-the-driver-to-kernel-L4.14.patch \
            file://0001-CORE-HIF-PCIe-only-support-one-instance.patch \
            file://0002-CORE-HIF-enable-pcie-MSI-feature.patch \
"

EXTRA_OEMAKE += " \
    CONFIG_ROME_IF=pci \
    CONFIG_WLAN_FEATURE_11W=y \
    CONFIG_WLAN_FEATURE_FILS=y \
    CONFIG_WLAN_WAPI_MODE_11AC_DISABLE=y \
    MODNAME=qca6174 \
"

RDEPENDS_${PN} += "firmware-qca6174"
