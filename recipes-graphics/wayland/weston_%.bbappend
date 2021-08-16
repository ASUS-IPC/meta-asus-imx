FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append += "file://0001-weston.ini-auto-adjust-desktop-shell-size.patch \
                   file://0001-desktop-shell-Don-t-reposition-views-when-output_lis.patch \
                   file://0002-desktop-shell-Re-position-views-when-outputs-change.patch \
                   file://0001-Fix-display-hotplugging-unplugging-crashes.patch \
                   file://weston-s2r.patch \
"
