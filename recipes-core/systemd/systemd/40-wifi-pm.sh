#!/bin/sh

declare -A mod_list
i=0

# Intel AX200
ax200=`/usr/sbin/lspci -n | grep "8086:2723" | head -1 | awk '{print $1}'`
if [ $ax200 ]; then
	mod_list[$i]=iwlmvm
	((i+=1))
fi

# RTL8822CE
rtl8822ce=`/usr/sbin/lspci -n | grep "10ec:c822" | head -1 | awk '{print $1}'`
if [ $rtl8822ce ]; then
	mod_list[$i]=88x2ce
	((i+=1))
fi

# QCA6174
qca6174=`/usr/sbin/lspci -n | grep "168c:003e" | head -1 | awk '{print $1}'`
if [ $qca6174 ]; then
	mod_list[$i]=`/usr/sbin/lspci -v -s $qca6174 | grep modules | awk '{print $3}'`
	((i+=1))
fi

echo "mod_list = ${mod_list[@]}"

case "$1" in
	pre)
		logger -t WiFi "Shutting down wifi"
		/usr/bin/nmcli radio wifi off
		sleep 1
		for mod in ${mod_list[@]}
		do
			logger -t WiFi "remove $mod"
			/sbin/modprobe -r $mod
		done
		;;
	post)
		logger -t WiFi "Bring WiFi back"
		for mod in ${mod_list[@]}
		do
			logger -t WiFi "insert $mod"
			/sbin/modprobe $mod
		done
		sleep 1
		/usr/bin/nmcli radio wifi on
		;;
esac
