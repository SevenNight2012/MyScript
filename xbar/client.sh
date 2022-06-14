#!/usr/bin/env bash
# 客户端脚本，将接收的参数传送给本地12345端口，由服务端运行对应的指令
param="$1"
if [[ "$param" == "pixel3" ]]; then
  #statements
  echo "pixel3" | nc localhost 12345
elif [[ "$param" == "pixel" ]]; then
  echo "pixel" | nc localhost 12345
elif [[ "$param" == "realme" ]]; then
  echo "realme" | nc localhost 12345
elif [[ "$param" == "pull" ]]; then
  echo "pull" | nc localhost 12345
fi
