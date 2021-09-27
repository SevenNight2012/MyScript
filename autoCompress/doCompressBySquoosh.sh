#!/usr/bin/env bash
# 单纯用来压缩图片的脚本，传入目录，则进行拷贝后，递归拷贝的目录压缩图片
# 传入图片，则直接压缩图片，然后覆盖
source ~/.bash_profile
logFile="$HOME/compress.log"

# 专门用来处理图片文件的函数
function compressImageFile {
  imageFile="$1"
  extension="${imageFile##*.}"
  thisFolder="$2"
  # 切换目录
  echo "$thisFolder"
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
function compressDir() {
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
}
# 主入口
function main() {
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

main "$@"
