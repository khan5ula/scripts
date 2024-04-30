#!/bin/bash

# Toggle mute
pactl set-sink-mute @DEFAULT_SINK@ toggle

# Check if muted
MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -oP '(?<=Mute: ).*')

# Determine the icon and text to use based on mute state
if [ "$MUTED" == "yes" ]; then
	TEXT="    muted"
else
	TEXT="    unmuted"
fi

# Send a notification
notify-send "$TEXT"
