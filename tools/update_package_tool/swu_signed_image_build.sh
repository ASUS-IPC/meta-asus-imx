#!/bin/bash
CMD=`realpath $0`
TOOLS_DIR=`dirname $CMD`
TOP_DIR=$(realpath $TOOLS_DIR/..)
WORK_DIR=$TOP_DIR/update_package_build

MODE="RSA-PKCS-1.5"
IMAGES="
        boot_pt_85196K.mirror.gz 
        $EXT4_FILE 
        $BOOT_FILE 
        emmc_bootpart.sh
       "
FILES="sw-description sw-description.sig $IMAGES"

for IMG in ${IMAGES}; do
    test ! -e "${IMG}" && echo "${IMG} not exists!!!" && exit -1; done

#if you use RSA
if [ x"$MODE" == "xRSA-PKCS-1.5" ]; then
    openssl dgst -sha256 -sign priv.pem sw-description > sw-description.sig
elif [ x"$MODE" == "xRSA-PSS" ]; then
    openssl dgst -sha256 -sign priv.pem -sigopt rsa_padding_mode:pss -sigopt rsa_pss_saltlen:-2 sw-description > sw-description.sig
else
    openssl cms -sign -in sw-description -out sw-description.sig -signer mycert.cert.pem -inkey mycert.key.pem -outform DER -nosmimecap -binary
fi

for i in $FILES; do
    echo $i;done | cpio -ov -H crc > $WORK_DIR/update.swu

