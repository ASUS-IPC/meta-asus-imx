#!/bin/sh

CONFIG_PATH=/etc/lte
CONFIG_FILE=${CONFIG_PATH}/lte.conf

check_config() {
    # Check config exists
    if [ ! -e ${CONFIG_PATH} ] ; then
        mkdir $CONFIG_PATH
    fi

    if [ ! -e ${CONFIG_FILE} ] ; then
        touch $CONFIG_FILE
        echo "APN=internet" >> $CONFIG_FILE
        echo "PIN=0000" >> $CONFIG_FILE
        echo "AUTO_CONNECT=y" >> $CONFIG_FILE
    fi
}

case $1 in
set-apn) 
    check_config
    sed -i "s/\(APN *= *\).*/\1$2/" $CONFIG_FILE
    ;;
set-pin)
    check_config
    sed -i "s/\(PIN *= *\).*/\1$2/" $CONFIG_FILE
    ;;
set-auto)
    if [ $2 == "y" -o $2 == "n" ] ; then
        check_config
        sed -i "s/\(AUTO_CONNECT *= *\).*/\1$2/" $CONFIG_FILE
    else
        echo "Parameter error"
    fi
    ;;
reboot-module)
    echo -ne "AT+CFUN=1,1\r" | microcom -t 5000 /dev/ttyUSB2
    ;;
reset)
    echo "APN=internet" > $CONFIG_FILE
    echo "PIN=0000" >> $CONFIG_FILE
    echo "AUTO_CONNECT=y" >> $CONFIG_FILE
    ;;
*)
    echo "Usage: $0 {set-apn [apn]| set-pin [pin]| set-auto [y/n]| reset}"
    ;;
esac