
PACKAGES =+ "${PN}-rtw88"

FILES:${PN}-rtw88 += " \
       ${nonarch_base_libdir}/firmware/rtw88 \
"
LICENSE:${PN}-rtw88 = "Firmware-rtlwifi_firmware"
RDEPENDS:${PN}-rtw88 += "${PN}-rtl-license"

