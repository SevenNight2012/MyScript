#!/usr/bin/env bash
# 提交代码
alias cm="git commit -am"

alias pros="osascript /Users/xuxingchen/.ScriptLauncher/as_toggle/projects.scpt"
alias close="bash /Users/xuxingchen/.ScriptLauncher/as_toggle/close-pro.sh "
alias push='gitPush(){
	mainBranch="dev"
	originBranch="dev"
	error=0
	while getopts :m:o: opts
	do
		case $opts in
			m)
				mainBranch=$OPTARG
				;;
			o)
				originBranch=$OPTARG
				;;
			\?)
				echo "error params $OPTARG,support -m mainBranch -o originBranch"
				error=1
				;;
			esac
		done
		echo $mainBranch
		echo $originBranch
		if [ $error = 0 ]
		then
			git pull main $mainBranch&&git push origin $originBranch&&gita
		fi
	};gitPush'
alias example1='example1(){
	for var in "$@"
	do
		echo $var
	done
};example1'
alias example2='example2(){
	while getopts :a:b:c:d: ARGS
	do
	case $ARGS in
	    a)
	        echo "发现 -a 选项"
	        echo "-a 选项的值是:$OPTARG"
	        ;;
	    b)
	        echo "发现 -b 选项"
	        echo "-b 选项的值是：$OPTARG"
	        ;;
	    c)
	        echo "发现 -c 选项"
	        echo "-c 选项的值是：$OPTARG"
	        ;;
	    d)
	        echo "发现 -d 参数"
	        echo "-c 选项的值是:$OPTARG"
	        ;;
	    *)
	    	echo "未知选项：$ARGS"
	      	;;
	esac
	done
};example2'
function pull() {
  result="$(git pull $@)"
  # echo "result >>>> $result"
  resultCode=$?
  # echo "result code >>>>>> $resultCode"
  if [ "$result" = "Already up-to-date." ]; then
    osascript -e "display notification \"没有代码更新，不用同步AAR\" with title \"AAR同步任务\""
  else
    if [ $resultCode = 0 ]; then
      if [ "$(pwd | grep "WeShare-Android")" != "" ]; then
        osascript -e "display notification \"开始同步AAR\" with title \"AAR同步任务\""
        publish
      fi
    else
      osascript -e "display notification \"合并失败\" with title \"AAR同步任务\""
    fi
  fi
}
function publish() {
  echo "pull" | nc localhost 12345
}
