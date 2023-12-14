#!/bin/bash

# Switch sound device
echo "Config default sound output device: $1";
pactl set-default-sink $1

# If you're playing sounds, switch running stream to your specified output.
echo "Switch running actvice stream to another sound output device"
pactl list sink-inputs | grep "Sink Input" | while read line
do
echo "Playback is running, find current stream index number"
echo $line | cut -d '#' -f2
echo "Move this running stream to sink: $1";
pactl move-sink-input `echo $line | cut -d'#' -f2` $1

done
