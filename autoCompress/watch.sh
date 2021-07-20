#!/usr/bin/env bash
source ~/.bash_profile
fswatch -0 -e ".*_optimized" \
  -e ".*_compress" \
  -e ".DS_Store" \
  -e ".*__MACOSX" \
  -e "未确认" \
  $IMAGE_DIR ${HOME}/Downloads | xargs -0 -n1 -I {} /Users/xuxingchen/.ScriptLauncher/autoCompress/doCompress.sh "{}"

# fswatch -0 /Users/xuxingchen/mrcd/img | while read -d "" event; do
#   # // do something with ${event}
#   echo "${event}"
# done
