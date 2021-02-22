#!/usr/bin/env bash
source list_txt.sh
# 读取配置文件，文件格式为一个快捷键对应一行，方法内部读取到行内容后会构建成Alfred需要的Json格式
function readConfig() {
  fileName="$1"
  keywords="$2"

  if [[ -e $fileName && -f $fileName ]]; then
    # output=""
    while read line; do
      subtext="${line/*[:,：]/}"
      # 选中显示项后可以使用cmd+l将文字放大，类似Android中的toast，再次使用cmd+l则可以隐藏大文字
      largeType="\"text\": {\"largetype\": \"$line\"}"
      jsonItem="{\"title\":\"$line\",\"arg\": \"$line\",\"subtitle\": \"$subtext\",\"valid\": false,$largeType}"
      if [[ "$keywords" != "" ]]; then
        # 如果有关键字的情况下，就去匹配关键字
        if [[ "$(echo "$line" | grep "$keywords")" != "" ]]; then
          appendOutputJson "$jsonItem"
        fi
      else
        # 没有关键字的情况下直接拼接json
        appendOutputJson "$jsonItem"
      fi
    done <$fileName
    # 容错处理，在没有任何内容的情况下，返回一个提示行
    if [[ "${output:=""}" == "" ]]; then
      output="$(errorOutput "无内容")"
    else
      output="$output ]}"
    fi
  else
    output="$(errorOutput "$fileName 文件不存在")"
  fi
  echo "$output" | cat
}

readConfig "$1" "$2"
