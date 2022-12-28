
PACKAGES =+ "${PN}-rtw88 \
             ${PN}-rtlbt"

FILES:${PN}-rtw88 += " \
       ${nonarch_base_libdir}/firmware/rtw88 \
"
FILES:${PN}-rtlbt += " \
       ${nonarch_base_libdir}/firmware/rtl_bt \
"

LICENSE:${PN}-rtw88 = "Firmware-rtlwifi_firmware"
RDEPENDS:${PN}-rtw88 += "${PN}-rtl-license"

