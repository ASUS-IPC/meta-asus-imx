SRC_URI = "git://github.com/KhronosGroup/SPIRV-Tools;branch=main;protocol=http;name=spirv-tools \
           git://github.com/KhronosGroup/SPIRV-Headers;name=spirv-headers;destsuffix=${SPIRV_HEADERS_LOCATION} \
           file://0002-spirv-lesspipe.sh-allow-using-generic-shells.patch"
