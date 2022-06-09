#!/usr/bin/env bash

deviceId="$1"
targetApk="$2"

# 修正只传apk文件名的参数
if [[ "$1" != "" ]]; then
  fileType="${1: -4}"
  if [[ "$fileType" == ".apk" ]]; then
    deviceId=""
    targetApk="$1"
  fi
fi

function setDevice {
  deviceInfo="$(adb devices)"
  deviceTextArray=($deviceInfo)
  # echo $splitText
  deviceId=${deviceTextArray[4]}
}

function checkDevice {
  if [[ "$deviceId" == "" ]]; then
    echo "请连接设备或设置ID"
    exit 1
  fi
}

function setApk {
  allApks="$(ls | grep .apk)"
  allApkArray=($allApks)
  apkCount=${#allApkArray[*]}
  if [[ $apkCount > 0 ]]; then
    #statements
    targetApk="${allApkArray[0]}"
    echo "自动选取apk: $targetApk"
  fi
}
function checkApk {
  if [[ "$targetApk" == "" ]]; then
    echo '请输入apk文件名'
    exit 1
  fi
}

if [[ "$deviceId" == "" ]]; then
  # adb devices
  setDevice
  checkDevice
fi
if [[ "$targetApk" == "" ]]; then
  setApk
  checkApk
fi
dirPath="$(pwd)"

# adb -s $deviceId install -f /Users/xuxingchen/mc/wangpan/gerrit/android/App/build/outputs/apk/netdisk/debug/BaiduNetDisk-debug.apk
# adb -s $deviceId install -f "$dirPath/$2"
# adb -s $deviceId shell am start com.baidu.netdisk/.ui.DefaultMainActivity

packageInfo="$(aapt dump badging $targetApk | grep package:)"
packageInfo="${packageInfo//\'/}"
launchInfo="$(aapt dump badging $targetApk | grep launchable-activity:)"
launchInfo="${launchInfo//\'/}"
packageInfoArray=($packageInfo)
launchInfoArray=($launchInfo)
package=${packageInfoArray[1]}
launchActivity=${launchInfoArray[1]}

echo "包名及启动类: ${package:5}/${launchActivity:5}"
# 安装apk包
adb -s $deviceId install -f "$dirPath/$targetApk"
adb -s $deviceId shell am start "${package:5}/${launchActivity:5}"
