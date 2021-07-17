#!/usr/bin/env bash
if [[ "$1" == "pull" ]]; then
  #statements
  cd ~/mrcd/github/WeShare-Android
  cat mavenLocal/optimizeProjects.json >~/.ScriptLauncher/nc/optimizeProjects.tmp
  cat ~/.ScriptLauncher/nc/project.json >mavenLocal/optimizeProjects.json
  ./gradlew syncLocalDeps
  result="同步成功"
  if [[ $? != 0 ]]; then
    result="同步失败"
  fi
  osascript -e "display notification \"$result\" with title \"AAR同步任务\""
  mv ~/.ScriptLauncher/nc/optimizeProjects.tmp mavenLocal/optimizeProjects.json
  time=$(date "+%Y-%m-%d %H:%M:%S")
  echo -e "发布 aar 完成 >>>>>> $time \n\n"
  # echo ">>>>>> $(pwd)"
  # cat build.gradle
fi
