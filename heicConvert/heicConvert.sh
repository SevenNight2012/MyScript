#!/usr/bin/env bash
# xargs -I {} ./converter.sh {}
path=$1
if [ -d "$path" ]; then
  # 处理文件夹
  cd "$path"
  ls *.HEIC | tr -d '\r' | xargs -I {} sips -s format jpeg -s formatOptions default {} --out {}.jpeg
elif [ -f "$path" ]; then
  # 普通文件
  extension="${path##*.}"
  if [[ "HEIC" == "$extension" || "heic" == "$extension" ]]; then
    sips -s format jpeg -s formatOptions default $path --out $path.jpeg
  fi
fi
