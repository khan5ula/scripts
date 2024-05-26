#!/bin/bash

# Unmute
pactl set-sink-mute @DEFAULT_SINK@ 0

# Lower volume
pactl set-sink-volume @DEFAULT_SINK@ -5%

# Get the current volume
VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)

# Send a notification
notify-send "Volume: $VOLUME" -h int:value:"$VOLUME" -h string:synchronous:volume
