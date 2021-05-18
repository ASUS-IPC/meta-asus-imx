#!/bin/sh

AT_PORT=/dev/ttyUSB2
ACK=/lte_ack
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

send_at_command() {
    if [ -e ${AT_PORT} ]; then
        echo -ne "${1}\r" | microcom -t 2000 ${AT_PORT} > ${ACK}
    else
        log "ERROR device not found"
    fi
}

check_sim_detect() {
    send_at_command "AT+QSIMDET?"
    res=`cat ${ACK} | tr -d '\r'`
    res=`echo ${res##*\ }`
    res=`echo ${res%%,*}`
    echo $res
}

set_sim_detect() {
    res=$(check_sim_detect)
    if [ "$res" != "$1" ]; then
        send_at_command "AT+QSIMDET=${1},0"
        reboot
    else
        log "Already is ${1}"
    fi
}

check_sim_slot() {
    res=`echo $(ex_gpio -s)`
    res=`echo ${res##*is}`
    res=`echo ${res%%Co*}`
    echo $res
}

reboot() {
    echo -ne "AT+CFUN=1,1\r" | microcom ${AT_PORT}
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
    if [ "$2" == "y" -o "$2" == "n" ] ; then
        check_config
        sed -i "s/\(AUTO_CONNECT *= *\).*/\1$2/" $CONFIG_FILE
    else
        log "Parameter error"
    fi
    ;;
set-sim)
    if [ "$2" == "0" ]; then
        ex_gpio -s ${2}
        if [ "$?" == "0" ]; then
            set_sim_detect 1
        else
            log "Set sim error"
        fi
    elif [ "$2" == "1" ]; then
        ex_gpio -s ${2}
        if [ "$?" == "0" ]; then
            set_sim_detect 0
        else
            log "Set sim error"
        fi
    else
        log "Parameter error"
    fi
    ;;
set-sim-detect)
    if [ "$2" == "0" -o "$2" == "1" ]; then
        set_sim_detect $2
    else
        log "Parameter error"
    fi
    ;;
check-sim-detect)
    echo $(check_sim_detect)
    ;;
reboot-module)
    reboot
    ;;
reset)
    echo "APN=internet" > $CONFIG_FILE
    echo "PIN=0000" >> $CONFIG_FILE
    echo "AUTO_CONNECT=y" >> $CONFIG_FILE
    ;;
start)
    version=`cat /proc/boardinfo`
    log "Start as ${version}"
    if [ "$version" == "PV100A" ]; then
        enable=$(check_sim_detect)
        log "Check sim detect = ${enable}"
        slot=$(check_sim_slot)
        log "Check sim slot = ${slot}"
        if [ "$enable" == "0" ] && [ "$slot" == "0" ]; then
            # enable sim detect when using sim slot 0
            log "Set sim detect to 1"
            set_sim_detect 1
        elif [ "$enable" == "1" ] && [ "$slot" == "1" ]; then
            # disable sim detect when using sim slot 1
            log "Set sim detect to 0"
            set_sim_detect 0
        else
            log "Check pass"
            check_config
            start_quectel_tool
        fi
    else
        log "Not supported version = ${version}"
        check_config
        start_quectel_tool
    fi
    ;;
stop)
    log "=== Disconnect ==="
    PID=`pidof quectel-CM`
    if [ "${PID}" != "" ]; then
        kill ${PID}
    fi
    ;;
set-wakeup)
    if [ "$2" == "0" ]; then
        send_at_command 'AT+QCFG="risignaltype","respective"'
        send_at_command 'AT+QCFG="urc/ri/ring","pulse"'
        send_at_command 'AT+QCFG="urc/ri/smsincoming","off"'
        send_at_command 'AT+QCFG="urc/ri/other","off"'
        wakeup_source_test 0 7
    elif [ "$2" == "1" ]; then
        send_at_command 'AT+QCFG="risignaltype","physical"'
        send_at_command 'AT+QCFG="urc/ri/ring","auto"'
        send_at_command 'AT+QCFG="urc/ri/smsincoming","pulse"'
        send_at_command 'AT+QCFG="urc/ri/other","off"'
        wakeup_source_test 1 7
    else
        log "Parameter error"
    fi
    ;;
*)
    echo "Connectivity: $0 {set-apn [apn]| set-pin [pin]| set-auto [y/n]| reset}"
    echo "Setting: $0 {set-sim [0/1] | check-sim-detect | set-sim-detect [0/1] | reboot-module | set-wakeup [0/1]}"
    ;;
esac
