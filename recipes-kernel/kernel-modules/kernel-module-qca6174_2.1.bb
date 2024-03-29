require kernel-module-qcacld-lea.inc

SUMMARY = "Qualcomm WiFi driver for QCA module 6174"

SRC_URI += "file://0001-QCA6174-disable-P2P-WFD.patch \
            file://0002-LEA3.0-CORE-porting-the-driver-to-kernel-L4.14.patch \
            file://0001-CORE-HIF-PCIe-only-support-one-instance.patch \
            file://0002-CORE-HIF-enable-pcie-MSI-feature.patch \
            file://0001-CORE-BMI-RF-align-the-utf-firmware-bin-name.patch \
            file://0001-CORE-add-pcie-multi_if_name-support.patch \
"

SRC_URI_append += "${@bb.utils.contains_any('MACHINE', 'imx8mq-pv100a', 'file://0001-QCA6174-add-Wi-Fi-LED-support.patch', '', d)}"
SRC_URI_append += "${@bb.utils.contains_any('MACHINE', 'imx8mq-pv100a2g', 'file://0001-QCA6174-add-Wi-Fi-LED-support.patch', '', d)}"
SRC_URI_append += "${@bb.utils.contains_any('MACHINE', 'imx8mq-p100ivm', 'file://0001-QCA6174-add-Wi-Fi-LED-support.patch', '', d)}"

EXTRA_OEMAKE += " \
    CONFIG_ROME_IF=pci \
    CONFIG_WLAN_FEATURE_11W=y \
    CONFIG_WLAN_FEATURE_FILS=y \
    CONFIG_WLAN_WAPI_MODE_11AC_DISABLE=y \
    MODNAME=qca6174 \
"

RDEPENDS_${PN} += "firmware-qca6174"
