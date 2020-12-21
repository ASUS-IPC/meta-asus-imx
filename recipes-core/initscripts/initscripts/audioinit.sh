#!/bin/sh

# Enable audio alc5616 lineout widgets
amixer -c1 cset name="DAC MIXL INF1 Switch" 1
amixer -c1 cset name="DAC MIXR INF1 Switch" 1
amixer -c1 cset name="Stereo DAC MIXL DAC L1 Switch" 1
amixer -c1 cset name="Stereo DAC MIXL DAC R1 Switch" 1
amixer -c1 cset name="HPO MIX DAC1 Switch" 1
amixer -c1 cset name="HP Playback Switch" 1 1
