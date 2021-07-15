#!/usr/bin/env bash
if [[ "$1" == "pull" ]]; then
  #statements
  cd ~/mrcd/github/WeShare-Android
  cat mavenLocal/optimizeProjects.json >mavenLocal/optimizeProjects.json.tmp
  cat ~/.ScriptLauncher/nc/project.json >mavenLocal/optimizeProjects.json
  ./gradlew syncLocalDeps
  result="同步成功"
  if [[ $? != 0 ]]; then
    result="同步失败"
  fi
  osascript -e "display notification \"$result\" with title \"AAR同步结果\""
  mv mavenLocal/optimizeProjects.json.tmp mavenLocal/optimizeProjects.json
  # echo ">>>>>> $(pwd)"
  # cat build.gradle
fi
