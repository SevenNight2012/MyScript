#!/usr/bin/env bash
device="$1"
if [[ "$device" == "pixel3" ]]; then
  #statements
  echo "pixel3" | nc localhost 12345
elif [[ "$device" == "pixel" ]]; then
  echo "pixel" | nc localhost 12345
fi
