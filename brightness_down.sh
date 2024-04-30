#!/bin/bash

# Lower brightness
brightnessctl -d amdgpu_bl1 set 10-%

# Get the current brightness
CURRENT_BRIGHTNESS=$(brightnessctl -d amdgpu_bl1 get)

# Get the maximum brightness
MAX_BRIGHTNESS=$(brightnessctl -d amdgpu_bl1 max)

# Calculate the brightness percentage
BRIGHTNESS_PERCENTAGE=$((CURRENT_BRIGHTNESS * 100 / MAX_BRIGHTNESS))

# Send a notification
notify-send "Brightness: $BRIGHTNESS_PERCENTAGE%" -h int:value:"$BRIGHTNESS_PERCENTAGE" -h string:synchronous:brightness
