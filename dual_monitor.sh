#! /bin/bash

second_monitor=$(xrandr | grep 'DVI.* connected' | awk '{ print $1 }')

if [ -n "$second_monitor" ]; then
  # Put the second monitor to the right and rotate vertically
  xrandr --output eDP --primary --mode 2560x1600 --rotate normal --output $second_monitor --mode 1920x1080 --rotate right --right-of eDP
  sleep 1
  bspc monitor $second_monitor -d 󱡶
  polybar secondbar &
  notify-send '  Second monitor connected'
else
  # Remove the disconnected monitor and the workspaces allocated to it
  xrandr --output DVI-I-2-1 --off
  disconnected_monitor=$(bspc query -M -m DVI-I-2-1)
  if [ -n "$disconnected_monitor" ]; then
    for desktop in $(bspc query -D -m $disconnected_monitor); do
      bspc desktop $desktop --remove
    done
    bspc monitor $disconnected_monitor --remove
  fi
fi
