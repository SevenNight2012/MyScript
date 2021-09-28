#!/usr/bin/env bash
# 这是调用压缩工具的脚本，主要负责将 Download目录下的图片压缩包移动到存储图片的目录下
# 然后解压缩对应的 zip 包，将复制解压缩的图片目录，然后对复制后的目录中的图片进行压缩
# 这样在存储图片的目录下会有两个目录，一个是原图目录，一个是带有_optimized后缀的压缩图目录
# 存储图片的目录是环境变量 IMAGE_DIR 所定义的
source ~/.bash_profile
# 加载真正的脚本
source "$COMPRESS_SCRIPT"

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
  downloadedFile="$1"
  fromUrl="$(mdls -name kMDItemWhereFroms "$downloadedFile" | grep "http://cn.hi-net.org")"
  echo "$downloadedFile 文件来源 >>$fromUrl"
  if [[ "$fromUrl" != "" ]]; then
    echo "将 $downloadedFile 移至 $IMAGE_DIR"
    mv "$downloadedFile" "$IMAGE_DIR"
  fi
}

# 将zip压缩包解压缩
# unzip -n $i -d $unzipDir -x __MACOSX/*
function unzipImages() {
  zipFile="$1"
  hasMacosxDir="$(unzip -l "$zipFile" | grep "__MACOSX/")"
  if [[ "$hasMacosxDir" == "" ]]; then
    # 不是系统压缩的
    unzip -n "$zipFile" -d "$unzipDir"
  else
    # 系统压缩包，内部包含 __MACOSX目录
    unzip -n "$zipFile" -d "$unzipDir" -x __MACOSX/*
  fi
}

result=""
for i in "$@"; do
  endFlag="${i: -4}"
  if [ -d "$i" ]; then
    if [ "${i%/*}" == "$IMAGE_DIR" ]; then
      echo "<table>" >"$logFile"
      compressDir "$i"
      echo "</table>" >>"$logFile"
      osascript -e "display notification \"压缩完成\""
    fi
  elif [ -f "$i" ]; then
    checkResult=true
    checkDir "$i"
    if [[ $checkResult == false ]]; then
      break
    fi
    unzipDir="${i%/*}"
    if [[ "$unzipDir" == "${HOME}/Downloads" ]]; then
      # 在download目录下面
      moveDownloadFile2ImgDir "$i"
    else
      # 在img目录下面
      unzipImages "$i"
    fi
  fi
done
# if [[ "$result" != "" ]]; then
#   osascript -e "display notification \"$result\" with title \"压缩结果\""
# fi
