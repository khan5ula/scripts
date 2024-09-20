#!/bin/bash

result=$(dunstctl is-paused)

if [ "$result" = "true" ]; then
  dunstctl close-all
  dunstctl set-paused false
  echo "Do Not Disturb mode disabled."
else
  dunstctl set-paused true
  echo "Do Not Disturb mode enabled."
fi
