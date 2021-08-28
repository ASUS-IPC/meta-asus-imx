#!/bin/sh
# set -x

export TPM2TOOLS_TCTI="device:/dev/tpm0"

version=1.0

getcap() {
    func "Display TPM capabilities in a human readable form."
    
    tpm2_startup -c
    # tpm2_getcap -l

    {
    	echo "*******************************************"
    	echo
    	echo "Get Capability"
    	echo
    	echo "*******************************************"
    	echo
    	item "1. algorithms"
    	item "2. commands"
    	item "3. pcrs"
    	item "4. properties-fixed"
    	item "5. properties-variable"
    	item "6. ecc-curves"
    	item "7. handles-transient"
    	item "8. handles-persistent"
    	item "9. handles-permanent"
    	item "10. handles-pcr"
    	item "11. handles-nv-index"
    	item "12. handles-loaded-session"
    	item "13. handles-saved-session"
    	read -p "Select test case: " test_item
    	echo
    }

    {
        case "$test_item" in
        	1)
        		test_item="algorithms"
        		;;
        	2)
        	    test_item="commands"
        	    ;;
        	3)
        		test_item="pcrs"
        		;;
        	4)
        		test_item="properties-fixed"
        		;;
        	5)
        		test_item="properties-variable"
        		;;
        	6)
        		test_item="ecc-curves"
        		;;
        	7)
        		test_item="handles-transient"
        		;;
        	8)
        		test_item="handles-persistent"
        		;;
        	9)
        		test_item="handles-permanent"
        		;;
        	10)
        		test_item="handles-pcr"
        		;;
        	11)
        		test_item="handles-nv-index"
        		;;
        	12)
        		test_item="handles-loaded-session"
        		;;
        	13)
        		test_item="handles-saved-session"
        		;;
        	*)
        		select_test_item
        		;;
        esac
    }

    if [ "$test_item" == "" ]; then
        echo ""
    else
        tpm2_getcap $test_item
	fi
}

aes() {
    func "TPM2.0 AES Encrypt & Decrypt"
    rm -rf tmp; mkdir tmp;
    tpm2_startup -c
    tpm2_clear -c p
    tpm2_getcap properties-variable
    
    # Create an AES key
    tpm2_createprimary -c ./tmp/primary.ctx
    tpm2_create -C ./tmp/primary.ctx -Gaes128 -u key.pub -r key.priv
    tpm2_load -C ./tmp/primary.ctx -u key.pub -r key.priv -c key.ctx
    
    # but you can flush them, you only need to do one, but I just flushed em all. Without an RM you have to perform all memory management. Use an RM.
    tpm2_flushcontext -t
    tpm2_getcap handles-transient
    
    tpm2_selftest -f
    
    # Encrypt and Decrypt some data
    echo "my secret" > secret.dat
    tpm2_encryptdecrypt -c key.ctx -o secret.enc secret.dat
    #cat secret.enc
    echo ""
    
    # but you can flush them, you only need to do one, but I just flushed em all. Without an RM you have to perform all memory management. Use an RM.
    tpm2_flushcontext -t
    tpm2_getcap handles-transient
    
    tpm2_encryptdecrypt -d -c key.ctx -o secret.dec secret.enc
    cat secret.dec

    tpm2_rc_decode 0x00000143
    
}

rsa() {
    func "Performs an RSA decryption operation using the TPM."
    rm -rf tmp; mkdir tmp
    
    var str

    tpm2_startup -c
    tpm2_clear -c p
    tpm2_getcap properties-variable
    
    info "Create an RSA key and load it"
    tpm2_createprimary -c ./tmp/primary.ctx
    tpm2_create -C ./tmp/primary.ctx -G rsa2048 -u ./tmp/key.pub -r ./tmp/key.priv
    tpm2_load -C ./tmp/primary.ctx -u ./tmp/key.pub -r ./tmp/key.priv -c ./tmp/key.ctx
    
    info "Encrypt using RSA"
    echo "my message" > msg.dat
    tpm2_rsaencrypt -c ./tmp/key.ctx -o msg.enc msg.dat
    str=`cat msg.enc`
    # result $str
    echo ""
    
    info "but you can flush them, you only need to do one, but I just flushed em all. Without an RM you have to perform all memory management. Use an RM."
    tpm2_flushcontext -t
    tpm2_getcap handles-transient
    
    info "Decrypt using RSA"
    tpm2_rsadecrypt -c ./tmp/key.ctx -o msg.ptext msg.enc
    
    str=`cat msg.ptext`
    result $str
}

nv_rw() {
    func "Read the data stored in a Non-Volatile (NV)s index."
    rm -rf ./tmp
    mkdir ./tmp

    info "Read 32 bytes from an index starting at offset 0"
    tpm2_startup -c
    tpm2_clear -c p
    
    tpm2_nvdefine -Q  1 -C o -s 32 -a "ownerread|policywrite|ownerwrite"
    
    echo "please123abc" > ./tmp/nv.test_w
    
    tpm2_nvwrite -Q 1 -C o -i ./tmp/nv.test_w
    
    tpm2_nvread -Q  1 -C o -s 32 -o ./tmp/nv.test_r
    
    str=`cat -v ./tmp/nv.test_r`
    result $str
}

nvreadlock() {
    func "Lock the Non-Volatile (NV) index for further reads."
    tpm2_startup -c
    tpm2_clear -c p
    tpm2_nvdefine -Q   1 -C o -s 32 -a "ownerread|policywrite|ownerwrite|read_stclear"

    echo "foobar" > nv.readlock
    
    tpm2_nvwrite -Q   0x01000001 -C o -i nv.readlock
    
    tpm2_nvread -Q   1 -C o -s 6 -o 0
    
    tpm2_nvreadlock -Q   1 -C o 
}

loadexternal() {
    func "Load an external object into the TPM."
    rm -rf tmp; mkdir tmp

    tpm2_startup -c
    tpm2_clear -c p
    tpm2_getcap properties-variable
    
    info "Load a TPM generated public key into the *owner* hierarchy"
    tpm2_createprimary -c ./tmp/primary.ctx
    tpm2_create -C ./tmp/primary.ctx -u ./tmp/pub.dat -r ./tmp/priv.dat
    tpm2_loadexternal -C o -u ./tmp/pub.dat -c ./tmp/pub.ctx
    
    info "Load an RSA public key into the *owner* hierarchy"
    openssl genrsa -out ./tmp/private.pem 2048
    openssl rsa -in ./tmp/private.pem -out ./tmp/public.pem -outform PEM -pubout
    tpm2_loadexternal -C o -Grsa -u ./tmp/public.pem -c ./tmp/key.ctx
    
    info "but you can flush them, you only need to do one, but I just flushed em all. Without an RM you have to perform all memory management. Use an RM."
    tpm2_flushcontext -t
    tpm2_getcap handles-transient
    
    info "Load an RSA key-pair into the *null* hierarchy"
    openssl genrsa -out ./tmp/private.pem 2048
    tpm2_loadexternal -C n -Grsa -r ./tmp/private.pem -c ./tmp/key.ctx
    
    info "Load an AES key into the *null* hierarchy"
    dd if=/dev/urandom of=./tmp/sym.key bs=1 count=16
    tpm2_loadexternal -C n -Gaes -r ./tmp/sym.key -c ./tmp/key.ctx

}

activatecredential() {
    func "Enables access to the credential qualifier to recover the credential secret."
    tpm2_startup -c
    tpm2_clear -c p
    
    echo "12345678" > secret.data
    
    tpm2_createek -Q -c 0x81010001 -G rsa -u ek.pub
    
    tpm2_createak -C 0x81010001 -c ak.ctx -G rsa -g sha256 -s rsassa -u ak.pub \
    -n ak.name -p akpass> ak.out
    
    file_size=`stat --printf="%s" ak.name`
    loaded_key_name=`cat ak.name | xxd -p -c $file_size`
    
    tpm2_makecredential -Q -e ek.pub  -s secret.data -n $loaded_key_name \
    -o mkcred.out
    
    tpm2_startauthsession --policy-session -S session.ctx
    
    TPM2_RH_ENDORSEMENT=0x4000000B
    tpm2_policysecret -S session.ctx -c $TPM2_RH_ENDORSEMENT
    
    tpm2_activatecredential -Q -c ak.ctx -C 0x81010001 -i mkcred.out \
    -o actcred.out -p akpass -P"session:session.ctx"
    
    tpm2_flushcontext session.ctx
}

Continue() {
    BLUE "Do TPM2.0 Continue $1"
    i=0
    while true
    do
    	i=$(($i+1))
    	info "Welcome $i times"
    	$1 $2 $3
    	sleep 5;
    done
}

# Terminal colors
NORMAL='\033[0m'
RED='\033[31m'
GREEN='\033[32;01m'
YELLOW='\033[33;01m'
BLUE='\033[34m'
PURPLE='\033[1;35m'
LIGHT_BLUE='\033[1;34m'

info() {
	printf "$YELLOW [info] %s $NORMAL\n" "$* "
}

result() {
	printf "$GREEN [result] %s $NORMAL\n" "$* "
}

fail() {
    printf "$RED [fail] %s $NORMAL\n" "$* "
}

func() {
    printf "$PURPLE [function] %s $NORMAL\n" "$* "
}

item() {
	printf "$LIGHT_BLUE [info] %s $NORMAL\n" "$* "
}

select_test_item()
{
	echo "*******************************************"
	echo
	echo "TPM2.0 Test tool v_$version"
	echo
	echo "*******************************************"
	echo
	item "1. Display TPM capabilities in a human readable form."
	item "2. Performs an RSA decryption operation using the TPM."
	item "3. Read the data stored in a Non-Volatile (NV)s index."
	item "4. Lock the Non-Volatile (NV) index for further reads."
	item "5. Load an external object into the TPM."
	item "continue. ex: ./tpm2_test.sh continue rsa"
	read -p "Select test case: " test_item
	echo
}

SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`/etc
if [ $1 ];then
	test_item=$1
else
	select_test_item
fi

case "$test_item" in
	1)
		getcap
		;;
	2)
	    rsa
	    ;;
	3)
	    nv_rw
	    ;;
	4)
	    nvreadlock
	    ;;
	5)
	    loadexternal
	    ;;
	continue)
		Continue $2 $3
	    ;;
	*)
		select_test_item
		;;
esac

# pause 'Press any key to exit...'

exit 0
