#!/bin/sh

# Default sound output device: HDMI
TARGET="alsa_output.platform-sound-hdmi.stereo-fallback"
RESULT=""

RESULT=$(pw-cli ls Node 2>/dev/null | tr -d '\r' | awk -v tgt="$TARGET" '
    BEGIN { found=0 }
    /^[[:space:]]*id[[:space:]]+[0-9]+,/ {
        id = $2
        sub(/,$/,"",id)
        next
    }
    {
        if (match($0, /node\.name[[:space:]]*=[[:space:]]*"([^"]+)"/, m)) {
            name = m[1]
            if (name == tgt) {
                print id
                found = 1
            }
        }
    }
    END {
        if (found == 0) exit 1
    }')

wpctl set-default "$RESULT"

exit
