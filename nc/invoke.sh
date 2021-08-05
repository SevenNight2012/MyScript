#!/usr/bin/env bash
if [[ "$1" == "pull" ]]; then

  osascript -e "display notification \"开始发布本地依赖\" with title \"AAR同步任务\""
  cd ~/mrcd/github/WeShare-Android
  cat mavenLocal/optimizeProjects.json >~/.ScriptLauncher/nc/optimizeProjects.tmp
  cat ~/.ScriptLauncher/nc/project.json >mavenLocal/optimizeProjects.json
  ./gradlew syncLocalDeps 1>/dev/null
  result="同步成功"
  if [[ $? != 0 ]]; then
    result="同步失败"
  fi
  osascript -e "display notification \"$result\" with title \"AAR同步任务\""
  mv ~/.ScriptLauncher/nc/optimizeProjects.tmp mavenLocal/optimizeProjects.json
  time=$(date "+%Y-%m-%d %H:%M:%S")
  echo -e "发布 aar 完成 >>>>>> $time \n\n"
elif [[ "$1" == "pixel3" ]]; then

  osascript -e "display notification \"开始解锁 Pixel3_XL\" with title \"解锁手机\""
  bash /Users/xuxingchen/.ScriptLauncher/tasker/894Y03QW1_unlock.sh
  osascript -e "display notification \"Pixel3_XL 解锁完成\" with title \"解锁手机\""
elif [[ "$1" == "pixel" ]]; then

  osascript -e "display notification \"开始解锁 Pixel_XL\" with title \"解锁手机\""
  bash /Users/xuxingchen/.ScriptLauncher/tasker/HT7320200007_unlock.sh
  osascript -e "display notification \"Pixel_XL 解锁完成\" with title \"解锁手机\""
fi
