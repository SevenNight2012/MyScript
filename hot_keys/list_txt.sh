#!/usr/bin/env bash
# 遍历目录中所有的txt文件，此方法暂时不用了，不想做关键字过滤了
function listTxt() {
  output=""
  for file in $(ls *.txt); do
    jsonItem="{\"title\":\"$file\",\"arg\": \"$file\",\"valid\": true}"
    appendOutputJson "$jsonItem"
  done
  if [[ "$output" == "" ]]; then
    output="$(errorOutput "没有TXT文件")"
  else
    output="$output ]}"
  fi
  echo "$output" | cat
}

# 拼接输出的json字符串
function appendOutputJson() {
  if [[ "${output:=""}" == "" ]]; then
    output="{\"items\": [ $1"
  else
    output="$output,$1"
  fi
}

# 错误输出
function errorOutput() {
  errMsg=""
  if [[ "$1" == "" ]]; then
    errMsg="未知错误"
  else
    errMsg="$1"
  fi
  echo "{\"items\": [ {\"title\":\"$errMsg\",\"arg\": \"$errMsg\",\"valid\": false} ]}"
}
