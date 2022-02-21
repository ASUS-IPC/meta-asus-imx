#!/bin/bash


script_path=/sbin/eth1_fw

if [ -f ${script_path}eth1.log ]
then
    sudo rm ${script_path}eth1.log
fi


sleep 10
eth1_ret=`sudo ifconfig | grep eth1`


if [ "$eth1_ret" = "" ]
then
    echo "eth1 fw empty" | tee -a ${script_path}/eth1.log
    NIC_value=$(sudo /usr/bin/EepromAccessTool | grep -ie "INVM" | awk 'FNR == 1 {print$1}')
    sudo /usr/bin/EepromAccessTool -NIC=$NIC_value -f=/lib/firmware/eth1_fw/eth1_fw.HEX
    sleep 2
    sudo reboot now
else
    echo "eth1 fw not empty" | tee -a ${script_path}/eth1.log
fi
