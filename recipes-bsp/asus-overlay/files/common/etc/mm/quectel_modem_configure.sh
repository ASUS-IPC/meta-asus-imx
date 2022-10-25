#!/bin/bash

#/devices/platform/soc@0/38200000.usb/xhci-hcd.3.auto/usb1/1-1/1-1.3/1-1.3:1.4/usbmisc/cdc-wdm0
TAG="modem_configure"

logger -t $TAG "start with device at $1"
if test -f /sys$1/../../../power/control; then
    echo "auto" > /sys$1/../../../power/control
    logger -t $TAG "set auto to power/control"
fi

if test -f /sys$1/../../../power/autosuspend_delay_ms; then
    echo "3000" > /sys$1/../../../power/autosuspend_delay_ms
    logger -t $TAG "set 3000 to power/autosuspend_delay_ms"
fi

if test -f /sys$1/../../../avoid_reset_quirk; then
    echo "1" > /sys$1/../../../avoid_reset_quirk
    logger -t $TAG "set 1 to avoid_reset_quirk"
fi

if test -f /sys$1/../../../power/persist; then
    echo "0" > /sys$1/../../../power/persist
    logger -t $TAG "set 0 to power/persist"
fi
logger -t $TAG "done"