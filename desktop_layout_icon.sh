#!/bin/bash

STATUS=$(bspc query -T -d | jq -r ".layout")

if [[ "$STATUS" == "tiled" ]]; then
  echo "%{T1}%{F#ebbcba}󰬁%{F-}%{T-}"
elif [[ "$STATUS" == "monocle" ]]; then
  echo "%{T3}%{F#ebbcba}󰫺%{F-}%{T-}"
fi
