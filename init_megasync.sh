#!/bin/bash

existing_process=$(xdotool search --name "megasync")

if [ ! -n "$existing_process" ]; then
  megasync &

  until xdotool search --onlyvisible --class '^megasync$'; do
    sleep .2
  done

  xdotool key Escape
fi
