#!/bin/bash

pgrep -f protonmail-bridge && killall protonmail-bridge
nohup protonmail-bridge --no-window >/dev/null 2>&1 &

sleep 10

if ! pidof -x thunderbird >/dev/null; then
  nohup thunderbird >/dev/null 2>&1 &
fi
