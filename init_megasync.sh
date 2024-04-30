#!/bin/bash

until xdotool search --onlyvisible ---class '^megasync$'; do
	sleep .2
done
xdotool key Escape
