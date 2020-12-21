MACHINE_FEATURES += " pci bluetooth wifi optee qca6174 rtl8822"

# ASUS BSP default providers
ASUS_DEFAULT_UBOOT = "u-boot-asus-imx"
PREFERRED_PROVIDER_u-boot_asus = "${ASUS_DEFAULT_UBOOT}"
PREFERRED_PROVIDER_virtual/bootloader_asus  = "${ASUS_DEFAULT_UBOOT}"

KERNEL_IMAGETYPE_mx8 = "Image"

SDCARD_GENERATION_COMMAND_mx8 = "generate_imx_sdcard_mx8"

DEFAULTTUNE_mx8 = "aarch64"

IMAGE_FSTYPES = "sdcard.bz2"
