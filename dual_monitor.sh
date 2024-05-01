#! /bin/bash

second_monitor=$(xrandr | grep 'DVI.* connected' | awk '{ print $1 }')

if [ -n "$second_monitor" ]; then
	xrandr --output eDP --primary --mode 2560x1600 --rotate normal --output $second_monitor --mode 1920x1080 --rotate right --right-of eDP
	sleep 1
	notify-send '  Second monitor connected'
fi
