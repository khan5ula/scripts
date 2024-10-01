#!/bin/bash

# Wait a moment to allow network and VPN to configure themselves
sleep 5

# Launch proton mail bridge
pgrep -f protonmail-bridge && killall protonmail-bridge
nohup protonmail-bridge --no-window >/dev/null 2>&1 &

# Wait a moment to allow proton mail bridge to configure
sleep 10

# Launch thunderbird
if ! pidof -x thunderbird >/dev/null; then
  nohup thunderbird >/dev/null 2>&1 &
fi
