#!/bin/bash

# Get the device ID for the touchpad
device_id=$(xinput list | grep 'SYNA2BA6:00 06CB:CE44 Touchpad' | grep -oP 'id=\K\d+')

# Check if device ID was found
if [ -z "$device_id" ]; then
	echo "Touchpad not found."
	exit 1
fi

# Set properties on the device
xinput set-prop $device_id 349 1
xinput set-prop $device_id 353 1
xinput set-prop $device_id 322 1
