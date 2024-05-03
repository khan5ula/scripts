#!/bin/bash

# Get the device ID for the touchpad
device_id=$(xinput list | grep 'Touchpad' | grep -oP 'id=\K\d+')

# Check if device ID was found
if [ -z "$device_id" ]; then
	echo "Touchpad not found."
	exit 1
fi

# Get the property IDs
tapping_enabled_id=$(xinput list-props $device_id | grep -m 1 'Tapping Enabled' | grep -o '[0-9]\+' | head -n 1)
natural_scrolling_id=$(xinput list-props $device_id | grep -m 1 'Natural Scrolling Enabled' | grep -o '[0-9]\+' | head -n 1)
tapping_drag_enabled_id=$(xinput list-props $device_id | grep -m 1 'Tapping Drag Lock Enabled (' | grep -o '[0-9]\+' | head -n 1)

# Set properties on the device
if [[ -n $tapping_enabled_id && -n $natural_scrolling_id && -n $tapping_drag_enabled_id ]]; then
	xinput set-prop $device_id $tapping_enabled_id 1
	xinput set-prop $device_id $natural_scrolling_id 1
	xinput set-prop $device_id $tapping_drag_enabled_id 1
else
	notify-send '  Could not set touchpad settings properly, please check xinput devices' -u critical
	exit 1
fi
