#!/usr/bin/env bash
echo "hello squoosh"

function main() {
  tempInfo=""
  for (( i = 0; i < 10; i++ )); do
    tempInfo="hello $i"
    readParams $i
    echo $tempInfo
  done
  if [[ $indexInfo == true ]]; then
    echo "true 判定成立"
  fi
}

function readParams {
  p1=$1
  if [[ $p1 == 2 ]]; then
    echo "special index 2 <<<<"
    indexInfo=false
  fi
}
main
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
      # 打开目标目录
      targetDir=${i##*/}_compress
      echo "打开目录: $IMAGE_DIR/$targetDir"
      open $IMAGE_DIR/$targetDir
    fi
  elif [ -f $i ]; then
    checkResult=true
    checkDir $i
    if [[ $checkResult == false ]]; then
      break
    fi
    unzipDir=${i%/*}
    if [[ "$unzipDir" == "${HOME}/Downloads" ]]; then
      # 在download目录下面
      moveDownloadFile2ImgDir $i
    else
      # 在img目录下面
      unzipImages $i
    fi
  fi
done
if [[ "$result" != "" ]]; then
  osascript -e "display notification \"$result\" with title \"压缩结果\""
fi

# 将zip压缩包解压缩
# unzip -n $i -d $unzipDir -x __MACOSX/*
function unzipImages {
  zipFile=$1
  hasMacosxDir="$(unzip -l $zipFile | grep "__MACOSX/")"
  if [[ "$hasMacosxDir" == "" ]]; then
    # 不是系统压缩的
    unzip -n $zipFile -d $unzipDir
  else
    # 系统压缩包，内部包含 __MACOSX目录
    unzip -n $zipFile -d $unzipDir -x __MACOSX/*
  fi
}

# 迁移download目录下的文件到imgDir目录下
function moveDownloadFile2ImgDir {
  # 定义变量：已下载的文件的
  downloadedFile=$1
  fromUrl="$(mdls -name kMDItemWhereFroms $downloadedFile | grep "http://cn.hi-net.org")"
  echo "$downloadedFile 文件来源 >>$fromUrl"
  if [[ "$fromUrl" != "" ]]; then
    echo "将 $downloadedFile 移至 $IMAGE_DIR"
    mv $downloadedFile $IMAGE_DIR
  fi
}

# 检查目录的合法性
function checkDir {
  filePath=$1
  if [[ $filePath != /* ]]; then
    result="$filePath 不是绝对路径"
    checkResult=false
  fi
  if [[ "$endFlag" != ".zip" ]]; then
    if [[ "$unzipDir" == "$IMAGE_DIR" ]]; then
      result="$filePath 不是zip文件"
    fi
    checkResult=false
  fi
}
