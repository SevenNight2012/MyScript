#!/usr/bin/env bash
# 单纯用来压缩图片的脚本，传入目录，则进行拷贝后，递归拷贝的目录压缩图片
# 传入图片，则直接压缩图片，然后覆盖
source ~/.bash_profile
runMain=false
logFile="$HOME/compress.html"

# 专门用来处理图片文件的函数
function compressImageFile() {
  imageFile="$1"
  extension="${imageFile##*.}"
  thisFolder="$2"
  # 切换目录

  cd "$thisFolder"
  if [[ "png" == "$extension" || "PNG" == "$extension" ]]; then
    # echo "$imageFile 是png"
    echo "<tr><td style=\"white-space: pre-line;\">" >>"$logFile"
    squoosh-cli \
      --quant '{"enabled":true,"zx":0,"numColors":64,"dither":0.5}' --oxipng '{"level":2,"interlace":false}' \
      "$imageFile" \
      >>"$logFile" 2>&1
    echo "</td></tr>" >>"$logFile"
  elif [[ "jpg" == "$extension" || "JPG" == "$extension" || "jpeg" == "$extension" || "JPEG" == "$extension" ]]; then
    # echo "$imageFile 是jpg文件"
    echo "<tr><td style=\"white-space: pre-line;\">" >>"$logFile"
    squoosh-cli \
      --mozjpeg '{"quality":75,"baseline":false,"arithmetic":false,"progressive":true,"optimize_coding":true,"smoothing":0,"color_space":3,"quant_table":3,"trellis_multipass":false,"trellis_opt_zero":false,"trellis_opt_table":false,"trellis_loops":1,"auto_subsample":true,"chroma_subsample":2,"separate_chroma_quality":false,"chroma_quality":75}' \
      "$imageFile" \
      >>"$logFile" 2>&1
    echo "</td></tr>" >>"$logFile"
    if [[ "jpeg" == "$extension" || "JPEG" == "$extension" ]]; then
      # jpeg格式的文件压缩完以后输出文件是jpg的，所以需要手动删除原图
      rm "$imageFile"
    fi
  elif [[ "webp" == "$extension" || "WEBP" == "$extension" ]]; then
    # echo "$imageFile 是webp"
    echo "<tr><td style=\"white-space: pre-line;\">" >>"$logFile"
    squoosh-cli \
      --webp '{"quality":75,"target_size":0,"target_PSNR":0,"method":4,"sns_strength":50,"filter_strength":60,"filter_sharpness":0,"filter_type":1,"partitions":0,"segments":4,"pass":1,"show_compressed":0,"preprocessing":0,"autofilter":0,"partition_limit":0,"alpha_compression":1,"alpha_filtering":1,"alpha_quality":100,"lossless":0,"exact":1,"image_hint":0,"emulate_jpeg_size":0,"thread_level":0,"low_memory":0,"near_lossless":100,"use_delta_palette":0,"use_sharp_yuv":0}' \
      "$imageFile" \
      >>"$logFile" 2>&1
    echo "</td></tr>" >>"$logFile"
  else
    echo "<tr><td><font color=\"RED\">" >>"$logFile"
    echo -e "${RED}$imageFile 不支持 $extension 类型的文件${NC}" >>"$logFile" 2>&1
    echo "</font></td></tr>" >>"$logFile"
  fi
}

# 递归遍历文件夹中的文件
function readFolder() {

  for element in $(ls "$1" | tr " " "\?"); do
    element=$(tr "\?" " " <<<$element)
    dir_or_file=$1"/"$element
    # echo "$dir_or_file  ${dir_or_file%/*}"
    if [ -d "$dir_or_file" ]; then
      readFolder "$dir_or_file"
    elif [[ -f "$dir_or_file" ]]; then
      # 文件
      # squoosh-cli --quant '{"enabled":true,"zx":0,"numColors":64,"dither":0.6}' --oxipng '{"level":2,"interlace":false}'
      compressImageFile "$dir_or_file" "${dir_or_file%/*}"
    fi
  done
}

# 使用Squoosh进行图片压缩
function compressDir() {
  imagePath="$1"
  parentPath="${imagePath%/*}"
  imageDir="${imagePath##*/}"
  optimizedDir="$parentPath/${imageDir}_optimized"

  # echo "路径：$imagePath">>"$logFile"
  # echo "父目录：$parentPath">>"$logFile"
  # echo "目录名：$imageDir">>"$logFile"
  # 复制文件夹
  cp -rf "$imagePath/" "$optimizedDir/"
  echo "<tr><td style=\"white-space: pre-line;\">" >>"$logFile"
  echo ">>>>>> 开始压缩 "$imagePath" 目录下的图片 <<<<<<" >>"$logFile" 2>&1
  echo "</td></tr>" >>"$logFile"
  readFolder "$optimizedDir"
  echo "<tr><td style=\"white-space: pre-line;\">" >>"$logFile"
  echo ">>>>>> 压缩结束 <<<<<<" >>"$logFile" 2>&1
  echo "</td></tr>" >>"$logFile"
  open "$optimizedDir"
}
# 主入口
function main() {
  echo "" >"$logFile"
  echo "$@" >"$logFile"
  for i in "$@"; do
    endFlag="${i: -4}"
    if [ -d "$i" ]; then
      # 处理文件夹
      compressDir "$i"
    elif [ -f "$i" ]; then
      # 普通文件
      compressImageFile "$i" "${i%/*}"
    fi
  done
}
if [[ $runMain == true ]]; then
  main "$@"
fi

# 适配自动操作输入参数成2倍的问题
function readAutomator() {
  count=$#
  count=$(($count / 2))
  echo "<table>" >"$logFile"
  for ((index = 1; index <= $count; index = index + 1)); do
    eval img=\${$index}
    # echo $img >>"$logFile"
    if [ -d "$img" ]; then
      # 处理文件夹
      compressDir "$img"
    elif [ -f "$img" ]; then
      # 普通文件
      compressImageFile "$img" "${img%/*}"
    fi
  done
  echo "</table>" >>"$logFile"
}
