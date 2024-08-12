#!/bin/bash

# Get the device ID for the touchpad
device_id=$(xinput list | grep 'Touchpad' | grep -oP 'id=\K\d+')

# Check if device ID was found
if [ -z "$device_id" ]; then
	echo "Touchpad not found."
	exit 1
fi

# Get the property ID
device_enabled_id=$(xinput list-props $device_id | grep -m 1 'Device Enabled' | grep -o '[0-9]\+' | head -n 1)

# Get the current setting, 1 or 0.
current_value=$(xinput list-props $device_id | grep -m 1 'Device Enabled' | grep -o '[0-9]\+' | tail -n 1)

# Reverse the current value
target_value=$((1 - current_value))

# Set the prop
if [[ -n $device_enabled_id ]]; then
	xinput set-prop $device_id $device_enabled_id $target_value
	if [[ $current_value == 1 ]]; then
		notify-send "Touchpad disabled"
	else
		notify-send "Touchpad enabled"
	fi
else
	notify-send '  Could not set touchpad settings properly, please check xinput devices' -u critical
	exit 1
fi
