#!/usr/bin/env bash
source ~/.bash_profile
# 分别唤醒两部设备上的tasker
bash ${OPEN_TASKER_SCRIPT_DIR}/open_script.sh 894Y03QW1 &&
  bash ${OPEN_TASKER_SCRIPT_DIR}/open_script.sh HT7320200007
