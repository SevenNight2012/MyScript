#!/bin/sh
# 这是调用压缩工具的脚本
source ~/.bash_profile
result=""
for i in "$@"; do
  endFlag="${i: -4}"
  if [ -d $i ]; then
    if [ "${i%/*}" == "$IMAGE_DIR" ]; then
      echo ">>>>>> 开始压缩 $i 目录下的图片 <<<<<<"
      result=$(echo $i | java -jar $Tiny_Launcher)
      # result=$(bash /Users/xuxingchen/temp/fswatch/testJar.sh)
      result="${result//\"/}"
    fi
  elif [ -f $i ]; then
    if [[ $i != /* ]]; then
      result="$i 不是绝对路径"
      break
    fi
    unzipDir=${i%/*}
    if [[ "$endFlag" != ".zip" ]]; then
      if [[ "$unzipDir" == "$IMAGE_DIR" ]]; then
        result="$i 不是zip文件"
      fi
      break
    fi
    # unzip -n $i -d $unzipDir -x __MACOSX/*
    hasMacosxDir="$(unzip -l $i | grep "__MACOSX/")"
    if [[ "$hasMacosxDir" == "" ]]; then
      # 不是系统压缩的
      unzip -n $i -d $unzipDir
    else
      # 系统压缩包，内部包含 __MACOSX目录
      unzip -n $i -d $unzipDir -x __MACOSX/*
    fi

  fi
done
if [[ "$result" != "" ]]; then
  osascript -e "display notification \"$result\" with title \"压缩结果\""
fi
