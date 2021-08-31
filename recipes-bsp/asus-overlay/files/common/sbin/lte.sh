#!/bin/bash

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
        echo "PIN=0000" >> $CONFIG_FILE
        echo "AUTO_CONNECT=y" >> $CONFIG_FILE
    fi
}

send_at_command() {
    if [ -e ${AT_PORT} ]; then
        echo -ne "${1}\r" | busybox microcom -t 2000 ${AT_PORT} > ${ACK}
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
    res=`echo ${res##*use\ }`
    res=`echo ${res%%slot*}`
    echo $res
}

reboot() {
    echo -ne "AT+CFUN=1,1\r" | busybox microcom ${AT_PORT}
}

log() {
	echo ${1}
	logger -t ${TAG} ${1}
}

log "do ${1}"
case $1 in
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
    if [ "$2" == "sim1" ]; then
        ex_gpio -s ${2}
        if [ "$?" == "0" ]; then
            set_sim_detect 1
        else
            log "Set sim error"
        fi
    elif [ "$2" == "sim2" ]; then
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
    echo "PIN=0000" > $CONFIG_FILE
    echo "AUTO_CONNECT=y" >> $CONFIG_FILE
    ;;
start)
    board=$(cat /proc/boardinfo)
    log "Start as ${board}, stop modemmanager first..."
    systemctl stop ModemManager
    while mmcli -B; do
        log "Waiting for modemmanager stops"
        sleep 1
    done

    case "$board" in
    "PV100A")
        enable=$(check_sim_detect)
        log "Check sim detect = ${enable}"
        slot=$(check_sim_slot)
        log "Check sim slot = ${slot}"
        if [ "$enable" == "0" ] && [ "$slot" == "sim1" ]; then
            # enable sim detect when using sim slot 0
            log "Enable sim detect"
            set_sim_detect 1
            exit 1
        elif [ "$enable" == "1" ] && [ "$slot" == "sim2" ]; then
            # disable sim detect when using sim slot 1
            log "Disable sim detect"
            set_sim_detect 0
            exit 1
        fi
        ;;
    "Tinker Edge R")
        boardVer=$(cat /proc/boardver)
        log "boardVer = ${boardVer}"
        enable=$(check_sim_detect)
        log "Check sim detect = ${enable}"
        check=$(echo "${boardVer} >= 1.04" | bc)
        if [ "$check" == "1" ]; then
            # enable sim detect when board version >= 1.04
            if [ "$enable" == "0" ]; then
                log "Enable sim detect"
                set_sim_detect 1
                exit 1
            fi
        else
            # disable sim detect when board version < 1.04
            if [ "$enable" == "1" ]; then
                log "Disable sim detect"
                set_sim_detect 0
                exit 1
            fi
        fi
        ;;
    *)
        log "Nothing to do with board = ${board}"
        ;;
    esac

    log "Check pass"
    log "Start modemmanager..."
    systemctl start ModemManager
    until mmcli -B; do
        log "Waiting for modemmanager starts"
        sleep 1
    done

    check_config
    lte_connect
    ;;
stop)
    log "=== Disconnect ==="
    lte_disconnect
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
    echo "Connectivity: $0 {set-pin [pin]| set-auto [y/n]| reset}"
    echo "Setting: $0 {set-sim [sim1/sim2] | check-sim-detect | set-sim-detect [0/1] | reboot-module | set-wakeup [0/1]}"
    ;;
esac
