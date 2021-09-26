#!/usr/bin/env bash
# 这是调用压缩工具的脚本
source ~/.bash_profile

# 检查目录的合法性
function checkDir() {
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

# 迁移download目录下的文件到imgDir目录下
function moveDownloadFile2ImgDir() {
  # 定义变量：已下载的文件的
  downloadedFile=$1
  fromUrl="$(mdls -name kMDItemWhereFroms $downloadedFile | grep "http://cn.hi-net.org")"
  echo "$downloadedFile 文件来源 >>$fromUrl"
  if [[ "$fromUrl" != "" ]]; then
    echo "将 $downloadedFile 移至 $IMAGE_DIR"
    mv $downloadedFile $IMAGE_DIR
  fi
}

# 将zip压缩包解压缩
# unzip -n $i -d $unzipDir -x __MACOSX/*
function unzipImages() {
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

# 递归遍历文件夹中的文件
function readFolder() {
  thisFolder="$1"
  for element in $(ls "$1" | tr " " "\?"); do
    # rightDirName=$1"/"$element
    element=$(tr "\?" " " <<<$element)
    dir_or_file=$1"/"$element
    if [ -d "$dir_or_file" ]; then
      readFolder "$dir_or_file"
    elif [[ -f "$dir_or_file" ]]; then
      # 文件
      # squoosh-cli --quant '{"enabled":true,"zx":0,"numColors":64,"dither":0.6}' --oxipng '{"level":2,"interlace":false}'
      echo "$dir_or_file"
    fi
  done
}

# 使用Squoosh进行图片压缩
function compressImageBySquoosh() {
  imagePath=$1
  parentPath=${imagePath%/*}
  imageDir=${imagePath##*/}

  echo "路径： $imagePath"
  echo "父目录：$parentPath"
  echo "目录： $imageDir"
  readFolder $imagePath
}

result=""
for i in "$@"; do
  endFlag="${i: -4}"
  if [ -d $i ]; then
    if [ "${i%/*}" == "$IMAGE_DIR" ]; then
      echo ">>>>>> 开始压缩 $i 目录下的图片 <<<<<<"
      compressImageBySquoosh $i
      # result=$(echo $i | java -jar $Tiny_Launcher)
      # # result=$(bash /Users/xuxingchen/temp/fswatch/testJar.sh)
      # result="${result//\"/}"
      # # 打开目标目录
      # targetDir=${i##*/}_optimized
      # echo "打开目录: $IMAGE_DIR/$targetDir"
      # open $IMAGE_DIR/$targetDir
      # osascript -e "do shell script \"open $IMAGE_DIR/$targetDir\""
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
