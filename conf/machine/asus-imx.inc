MACHINE_FEATURES += " pci bluetooth wifi optee rtl8822 qca6174"

# ASUS BSP default providers
ASUS_DEFAULT_UBOOT = "u-boot-asus-imx"
PREFERRED_PROVIDER_u-boot_asus = "${ASUS_DEFAULT_UBOOT}"
PREFERRED_PROVIDER_virtual/bootloader_asus  = "${ASUS_DEFAULT_UBOOT}"

ASUS_DEFAULT_KERNEL = "linux-asus-imx"
PREFERRED_PROVIDER_virtual/kernel_asus = "${ASUS_DEFAULT_KERNEL}"
PREFERRED_VERSION_linux-asus-imx = "5.10"

VOLATILE_LOG_DIR = "no"

IMAGE_INSTALL_append += " \
	asus-overlay \
	gptfdisk \
	exfat-utils \
	fuse-exfat \
	ntfs-3g \
	networkmanager \
	networkmanager-nmtui \
	iotedge-daemon \
	iotedge-cli \
	docker \
	docker-ce \
	ca-certificates \
	canopensocket \
	can-utils-j1939 \
"

MACHINE_EXTRA_RRECOMMENDS_append = " ${@bb.utils.contains('MACHINE_FEATURES', 'qca6174', 'kernel-module-qca6174 firmware-qca6174 firmware-qca6174-usb qca-tools', '', d)}"
MACHINE_EXTRA_RRECOMMENDS_append = " ${@bb.utils.contains('MACHINE_FEATURES', 'rtl8822', 'rtk-bt-fw', '', d)}"

SOC_DEFAULT_WKS_FILE_asus = "asus-imx-boot-bootpart.wks.in"

IMAGE_FSTYPES = "wic.bz2"
