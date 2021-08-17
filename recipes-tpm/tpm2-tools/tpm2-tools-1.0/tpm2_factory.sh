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
    	echo "1. algorithms"
    	echo "2. commands"
    	echo "3. pcrs"
    	echo "4. properties-fixed"
    	echo "5. properties-variable"
    	echo "6. ecc-curves"
    	echo "7. handles-transient"
    	echo "8. handles-persistent"
    	echo "9. handles-permanent"
    	echo "10. handles-pcr"
    	echo "11. handles-nv-index"
    	echo "12. handles-loaded-session"
    	echo "13. handles-saved-session"
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

select_test_item()
{
	test_item=1
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
