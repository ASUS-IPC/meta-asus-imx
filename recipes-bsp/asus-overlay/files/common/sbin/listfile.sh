#!/bin/sh

need_reboot=0

directory="/data/overlay-etc/upper/init.d"
if [ "$(ls -A $directory)" ]; then
     echo  "overlay: /data/overlay-etc/upper/init.d is not empty" > /dev/kmsg
     mount -o remount,rw /
     mv /data/overlay-etc/upper/init.d/* /etc/init.d
     need_reboot=1
else
     echo  "overlay: /data/overlay-etc/upper/init.d is empty" > /dev/kmsg
fi



search_dir=/data/overlay-etc/upper/rc0.d
for entry in "$search_dir"/*
do
   if [ -L $entry ]; then
       echo  "overlay: $entry is a symlink!" > /dev/kmsg
       filename=$(basename "$entry")
       echo  "overlay: filename is $filename" > /dev/kmsg
       mount -o remount,rw /
       mv $entry /etc/rc0.d/
       need_reboot=1
   else
       echo "overlay: $entry not a symlink!" > /dev/kmsg
       filename=$(basename "$entry")
       echo  "overlay: filename is $filename" > /dev/kmsg

       if [ "$filename" != "*" ]; then
           mount -o remount,rw /
           rm -rf $entry
           echo  "overlay: rm -rf $entry" > /dev/kmsg
           rm -rf /etc/rc0.d/$filename
           echo  "overlay: rm -rf $filename" > /dev/kmsg
           need_reboot=1
       fi
   fi
done

search_dir=/data/overlay-etc/upper/rc1.d
for entry in "$search_dir"/*
do
   if [ -L $entry ]; then
       echo  "overlay: $entry is a symlink!" > /dev/kmsg
       filename=$(basename "$entry")
       echo  "overlay: filename is $filename" > /dev/kmsg
       mount -o remount,rw /
       mv $entry /etc/rc1.d/
       need_reboot=1
   else
       echo "overlay: $entry not a symlink!" > /dev/kmsg
       filename=$(basename "$entry")
       echo  "overlay: filename is $filename" > /dev/kmsg

       if [ "$filename" != "*" ]; then
           mount -o remount,rw /
           rm -rf $entry
           echo  "overlay: rm -rf $entry" > /dev/kmsg
           rm -rf /etc/rc1.d/$filename
           echo  "overlay: rm -rf $filename" > /dev/kmsg
           need_reboot=1
       fi
   fi
done

search_dir=/data/overlay-etc/upper/rc2.d
for entry in "$search_dir"/*
do
   if [ -L $entry ]; then
       echo  "overlay: $entry is a symlink!" > /dev/kmsg
       filename=$(basename "$entry")
       echo  "overlay: filename is $filename" > /dev/kmsg
       mount -o remount,rw /
       mv $entry /etc/rc2.d/
       need_reboot=1
   else
       echo "overlay: $entry not a symlink!" > /dev/kmsg
       filename=$(basename "$entry")
       echo  "overlay: filename is $filename" > /dev/kmsg

       if [ "$filename" != "*" ]; then
           mount -o remount,rw /
           rm -rf $entry
           echo  "overlay: rm -rf $entry" > /dev/kmsg
           rm -rf /etc/rc2.d/$filename
           echo  "overlay: rm -rf $filename" > /dev/kmsg
           need_reboot=1
       fi
   fi
done

search_dir=/data/overlay-etc/upper/rc3.d
for entry in "$search_dir"/*
do
   if [ -L $entry ]; then
       echo  "overlay: $entry is a symlink!" > /dev/kmsg
       filename=$(basename "$entry")
       echo  "overlay: filename is $filename" > /dev/kmsg
       mount -o remount,rw /
       mv $entry /etc/rc3.d/
       need_reboot=1
   else
       echo "overlay: $entry not a symlink!" > /dev/kmsg
       filename=$(basename "$entry")
       echo  "overlay: filename is $filename" > /dev/kmsg

       if [ "$filename" != "*" ]; then
           mount -o remount,rw /
           rm -rf $entry
           echo  "overlay: rm -rf $entry" > /dev/kmsg
           rm -rf /etc/rc3.d/$filename
           echo  "overlay: rm -rf $filename" > /dev/kmsg
           need_reboot=1
       fi
   fi
done

search_dir=/data/overlay-etc/upper/rc4.d
for entry in "$search_dir"/*
do
   if [ -L $entry ]; then
       echo  "overlay: $entry is a symlink!" > /dev/kmsg
       filename=$(basename "$entry")
       echo  "overlay: filename is $filename" > /dev/kmsg
       mount -o remount,rw /
       mv $entry /etc/rc4.d/
       need_reboot=1
   else
       echo "overlay: $entry not a symlink!" > /dev/kmsg
       filename=$(basename "$entry")
       echo  "overlay: filename is $filename" > /dev/kmsg

       if [ "$filename" != "*" ]; then
           mount -o remount,rw /
           rm -rf $entry
           echo  "overlay: rm -rf $entry" > /dev/kmsg
           rm -rf /etc/rc4.d/$filename
           echo  "overlay: rm -rf $filename" > /dev/kmsg
           need_reboot=1
       fi
   fi
done

search_dir=/data/overlay-etc/upper/rc5.d
for entry in "$search_dir"/*
do
   if [ -L $entry ]; then
       echo  "overlay: $entry is a symlink!" > /dev/kmsg
       filename=$(basename "$entry")
       echo  "overlay: filename is $filename" > /dev/kmsg
       mount -o remount,rw /
       mv $entry /etc/rc5.d/
       need_reboot=1
   else
       echo "overlay: $entry not a symlink!" > /dev/kmsg
       filename=$(basename "$entry")
       echo  "overlay: filename is $filename" > /dev/kmsg

       if [ "$filename" != "*" ]; then
           mount -o remount,rw /
           rm -rf $entry
           echo  "overlay: rm -rf $entry" > /dev/kmsg
           rm -rf /etc/rc5.d/$filename
           echo  "overlay: rm -rf $filename" > /dev/kmsg
           need_reboot=1
       fi
   fi
done

search_dir=/data/overlay-etc/upper/rc6.d
for entry in "$search_dir"/*
do
   if [ -L $entry ]; then
       echo  "overlay: $entry is a symlink!" > /dev/kmsg
       filename=$(basename "$entry")
       echo  "overlay: filename is $filename" > /dev/kmsg
       mount -o remount,rw /
       mv $entry /etc/rc6.d/
       need_reboot=1
   else
       echo "overlay: $entry not a symlink!" > /dev/kmsg
       filename=$(basename "$entry")
       echo  "overlay: filename is $filename" > /dev/kmsg

       if [ "$filename" != "*" ]; then
           mount -o remount,rw /
           rm -rf $entry
           echo  "overlay: rm -rf $entry" > /dev/kmsg
           rm -rf /etc/rc6.d/$filename
           echo  "overlay: rm -rf $filename" > /dev/kmsg
           need_reboot=1
       fi
   fi
done

search_dir=/data/overlay-etc/upper/rcS.d
for entry in "$search_dir"/*
do
   if [ -L $entry ]; then
       echo  "overlay: $entry is a symlink!" > /dev/kmsg
       filename=$(basename "$entry")
       echo  "overlay: filename is $filename" > /dev/kmsg
       mount -o remount,rw /
       mv $entry /etc/rcS.d/
       need_reboot=1
   else
       echo "overlay: $entry not a symlink!" > /dev/kmsg
       filename=$(basename "$entry")
       echo  "overlay: filename is $filename" > /dev/kmsg
       if [ "$filename" != "*" ]; then
           mount -o remount,rw /
           rm -rf $entry
           echo  "overlay: rm -rf $entry" > /dev/kmsg
           rm -rf /etc/rcS.d/$filename
           echo  "overlay: rm -rf $filename" > /dev/kmsg
           need_reboot=1
       fi
   fi
done

if [ $need_reboot -eq 1 ]; then
    echo "overlay: need reboot" > /dev/kmsg
    reboot
else
    echo "overlay: not need reboot" > /dev/kmsg
fi
