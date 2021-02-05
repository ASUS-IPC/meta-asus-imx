#!/bin/sh

CONFIG_PATH=/etc/lte
CONFIG_FILE=${CONFIG_PATH}/lte.conf
TAG="LTE"

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

start_quectel_tool() {
	. $CONFIG_FILE
	if [ "$AUTO_CONNECT" == "y" ]; then
		if [ "$APN" == "" ]; then
			if [ "$PIN" == "" ]; then
				quectel-CM &
			else
				quectel-CM -p $PIN &
			fi
		else
			if [ "$PIN" == "" ]; then
				quectel-CM -s $APN &
			else
				quectel-CM -s $APN -p $PIN &
			fi
		fi
		PID=`pidof quectel-CM`
		log "=== Start at ${PID} ==="
	else
		log "AUTO_CONNECT not enabled"
	fi
}

log() {
	echo ${1}
	logger -t ${TAG} ${1}
}

log "do ${1}"
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
        log "Parameter error"
    fi
    ;;
set-sim)
    if [ "$2" == "0" -o "$2" == "1" ]; then
        ex_gpio -s ${2}
        echo -ne "AT+CFUN=1,1\r" | microcom /dev/ttyUSB2
    else
        log "Parameter error"
    fi
    ;;
reboot-module)
    echo -ne "AT+CFUN=1,1\r" | microcom /dev/ttyUSB2
    ;;
reset)
    echo "APN=internet" > $CONFIG_FILE
    echo "PIN=0000" >> $CONFIG_FILE
    echo "AUTO_CONNECT=y" >> $CONFIG_FILE
    ;;
start)
    check_config
    start_quectel_tool
    ;;
stop)
    log "=== Disconnect ==="
    PID=`pidof quectel-CM`
    if [ "${PID}" != "" ]; then
        kill ${PID}
    fi
    ;;
*)
    echo "Usage: $0 {set-apn [apn]| set-pin [pin]| set-auto [y/n]| set-sim [0/1]| reset| reboot-module| start| stop}"
    ;; 
esac
