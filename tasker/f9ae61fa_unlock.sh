#!/usr/bin/env bash
source ~/.bash_profile
status="$(adb -s f9ae61fa shell dumpsys window policy | grep screenState)"
key="screenState="
keyLength=${#key}
status="${status// /}"
hint=""
if [[ "SCREEN_STATE_OFF" == "${status:12}" ]]; then
  adb -s f9ae61fa shell input keyevent 26
  # sleep 2s
  # adb -s HT7320200007 shell input swipe 750 2500 750 500

  hint="屏幕解锁成功"
else
  hint="当前屏幕无需解锁"
fi
output="{
  \"items\": [
    {
      \"title\": \"$hint\",
      \"valid\": true,
      \"arg\": \"$hint\",
    }
  ]
}"
echo "$output" | cat
