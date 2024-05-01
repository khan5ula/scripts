#! /bin/bash

maim -g $(xrandr --query | grep " connected primary" | awk '{ print $4 }') ~/Pictures/screenshots/screenshot_$(date +%F_%T).png

sleep 1

notify-send "󰄁 Screenshot taken"
