#!/usr/bin/env bash
# 这是调用压缩工具的脚本，主要负责将 Download目录下的图片压缩包移动到存储图片的目录下
# 然后解压缩对应的 zip 包，将复制解压缩的图片目录，然后对复制后的目录中的图片进行压缩
# 这样在存储图片的目录下会有两个目录，一个是原图目录，一个是带有_optimized后缀的压缩图目录
# 存储图片的目录是环境变量 IMAGE_DIR 所定义的
source ~/.bash_profile
logFile="$HOME/compress.log"

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

# 专门用来处理图片文件的函数
function compressImageFile {
  imageFile="$1"
  extension="${imageFile##*.}"
  thisFolder="$2"
  # 切换目录
  cd "$thisFolder"

  if [[ "png" == "$extension" || "PNG" == "$extension" ]]; then
    squoosh-cli \
    --quant '{"enabled":true,"zx":0,"numColors":64,"dither":0.5}' --oxipng '{"level":2,"interlace":false}'\
    "$imageFile"\
    >> "$logFile" 2>&1
  elif [[ "jpg" == "$extension" || "JPG" == "$extension" || "jpeg" == "$extension" || "JPEG" == "$extension" ]]; then
    # echo "$imageFile 是jpg文件"
    squoosh-cli \
    --mozjpeg '{"quality":75,"baseline":false,"arithmetic":false,"progressive":true,"optimize_coding":true,"smoothing":0,"color_space":3,"quant_table":3,"trellis_multipass":false,"trellis_opt_zero":false,"trellis_opt_table":false,"trellis_loops":1,"auto_subsample":true,"chroma_subsample":2,"separate_chroma_quality":false,"chroma_quality":75}'\
    "$imageFile"\
    >>"$logFile" 2>&1
    if [[ "jpeg" == "$extension" || "JPEG" == "$extension" ]]; then
      # jpeg格式的文件压缩完以后输出文件是jpg的，所以需要手动删除原图
      rm "$imageFile"
    fi
  elif [[ "webp" == "$extension" || "WEBP" == "$extension" ]]; then
    squoosh-cli \
    --webp '{"quality":75,"target_size":0,"target_PSNR":0,"method":4,"sns_strength":50,"filter_strength":60,"filter_sharpness":0,"filter_type":1,"partitions":0,"segments":4,"pass":1,"show_compressed":0,"preprocessing":0,"autofilter":0,"partition_limit":0,"alpha_compression":1,"alpha_filtering":1,"alpha_quality":100,"lossless":0,"exact":1,"image_hint":0,"emulate_jpeg_size":0,"thread_level":0,"low_memory":0,"near_lossless":100,"use_delta_palette":0,"use_sharp_yuv":0}'\
    "$imageFile"\
    >>"$logFile" 2>&1
  else
    echo "$imageFile 不支持 $extension 类型的文件">>"$logFile" 2>&1
  fi
}

# 递归遍历文件夹中的文件
function readFolder() {
  thisFolder="$1"

  for element in $(ls "$1" | tr " " "\?"); do
    element=$(tr "\?" " " <<<$element)
    dir_or_file=$1"/"$element
    if [ -d "$dir_or_file" ]; then
      readFolder "$dir_or_file"
    elif [[ -f "$dir_or_file" ]]; then
      # 文件
      # squoosh-cli --quant '{"enabled":true,"zx":0,"numColors":64,"dither":0.6}' --oxipng '{"level":2,"interlace":false}'
      compressImageFile "$dir_or_file" "$thisFolder"
    fi
  done
}

# 使用Squoosh进行图片压缩
function compressImageBySquoosh() {
  imagePath="$1"
  parentPath="${imagePath%/*}"
  imageDir="${imagePath##*/}"
  optimizedDir="$parentPath/${imageDir}_optimized"

  # echo "路径：$imagePath"
  # echo "父目录：$parentPath"
  # echo "目录名：$imageDir"
  # 复制文件夹
  cp -rf "$imagePath/" "$optimizedDir/"
  echo "">"$logFile"
  echo ">>>>>> 开始压缩 "$i" 目录下的图片 <<<<<<">>"$logFile" 2>&1
  readFolder "$optimizedDir"
  echo ">>>>>> 压缩结束 <<<<<<">>"$logFile" 2>&1
  open "$optimizedDir"
  osascript -e "display notification \"压缩完成\""
  # open "$logFile"
  # result="$(cat "$logFile")"
  # result="$result\n$result"
  # osascript -e "tell app \"System Events\" to display dialog \"$result\""
  # osascript -e "do shell script \"open $IMAGE_DIR/$targetDir\""
}

result=""
for i in "$@"; do
  endFlag="${i: -4}"
  if [ -d "$i" ]; then
    if [ "${i%/*}" == "$IMAGE_DIR" ]; then
      compressImageBySquoosh "$i"
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
