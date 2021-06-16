#!/bin/sh
# 这是调用压缩工具的脚本
for i in "$@"; do
  if [ -d $i ]; then
    echo "$i"
    result=$(echo $i | java -jar $Tiny_Launcher)
    # result=$(bash /Users/xuxingchen/temp/fswatch/testJar.sh)
    result="${result//\"/}"
    osascript -e "display notification \"$result\" with title \"压缩结果\""
  fi
done
