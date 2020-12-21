#!/bin/sh

# Source lte config
CONF=/etc/lte/lte.conf
USB_PORT=/dev/ttyUSB0
LOG=/etc/lte/log
CHECK_DURATION=0.5

run_quectel_tool() {
    log "run quectel-CM..."
    if [ "$APN" == "" ]; then
        log "no APN insert"
        if [ "$PIN" == "" ]; then
            log "no PIN insert"
            quectel-CM > /dev/null 2>&1 &
        else
            quectel-CM -p $PIN > /dev/null 2>&1 &
        fi
    else
        if [ "$PIN" == "" ]; then
            log "no PIN insert"
            quectel-CM -s $APN > /dev/null 2>&1 &
        else
            quectel-CM -s $APN -p $PIN > /dev/null 2>&1 &
        fi
    fi
}

log() {
    date=`date`
    echo "${date}:${1}" >> ${LOG}
}

source_config() {
    if [ -e $CONF ] ; then
        . $CONF
    else
        log "${CONF} not found"
        AUTO_CONNECT="n"
    fi
}

echo "" > ${LOG}
log "Start"
source_config
while [ "$AUTO_CONNECT" == "y" ]; do
    source_config
    sleep ${CHECK_DURATION}
    if [ "$USB_CONNECTED" == "1" ]; then
        # Already connected
        if [ ! -e ${USB_PORT} ]; then
            log "USB port disconnect"
            USB_CONNECTED=0
        fi
    else
        # Not connect yet
        if [ -e ${USB_PORT} ]; then
            log "USB port connected"
            QUECTEL_CM_PID=`pidof quectel-CM`
            if [ "$?" -eq "0" ]; then
                if [ "${QUECTEL_CM_PID}" != "0" ]; then
                    log "kill previous quectel-CM ${QUECTEL_CM_PID}"
                    kill ${QUECTEL_CM_PID}
                fi
            fi
            run_quectel_tool
            USB_CONNECTED=1
        fi
    fi
done
log "End"