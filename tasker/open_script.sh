#!/usr/bin/env bash
source ~/.bash_profile
echo ""
device="$1"
# adbResult="$(adb devices | grep 894Y03QW1)"
# if [[ $adbResult != "" ]]; then
# 解锁屏幕
unlockResult="$(bash $OPEN_TASKER_SCRIPT_DIR/${device}_unlock.sh | grep 屏幕解锁成功)"
if [[ $unlockResult != "" ]]; then
  echo "唤醒屏幕"
fi
# 休眠1秒后唤醒tasker
sleep 1s
adb -s $device shell am start -n net.dinglisch.android.taskerm/.Tasker
sleep 3s
adb -s $device shell input keyevent 4
adb -s $device shell input keyevent 4
time=$(date "+%Y-%m-%d %H:%M:%S")
echo "设备 $device 在 $time 唤醒tasker成功"
# fi
