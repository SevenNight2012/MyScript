#!/usr/bin/env bash
source ~/.bash_profile
status="$(adb -s 894Y03QW1 shell dumpsys window policy | grep screenState)"
key="screenState="
keyLength=${#key}
status="${status// /}"
hint=""
if [[ "SCREEN_STATE_OFF" == "${status:12}" ]]; then
  adb -s 894Y03QW1 shell input keyevent 26
  sleep 0.5s
  adb -s 894Y03QW1 shell input swipe 750 2500 750 500
  sleep 0.5s
  adb -s 894Y03QW1 shell input motionevent DOWN 350 1700
  adb -s 894Y03QW1 shell input motionevent MOVE 1100 1700
  adb -s 894Y03QW1 shell input motionevent MOVE 1100 2400
  adb -s 894Y03QW1 shell input motionevent UP 1100 2400
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
