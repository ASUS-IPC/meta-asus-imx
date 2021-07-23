#!/bin/sh

iface=$1
counter=0
while [ $counter -le 3 ]
do
	/sbin/ip link set $iface up type can bitrate 125000 listen-only on
	if [ $( ifconfig -s | grep $iface ) ]; then 
		echo "$iface is up!"
		exit
	fi
	echo "$iface is up fail, rety again"
	counter=`expr $counter + 1`
done

echo "$iface is up fail over 3 times"
