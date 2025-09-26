#!/bin/bash

while true
do
	status=$(timedatectl status | grep "System clock synchronized" | awk '{print $4}')
	printf "status = $status\n"
	sleep 5
	if [ "$status" == "yes" ];
	then
		break
	fi
done

printf "exit"
