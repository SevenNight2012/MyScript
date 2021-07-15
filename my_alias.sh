#!/usr/bin/env bash
alias goto="cd "
alias subl="open -a /Applications/Sublime\ Text.app"
alias gita="open https://github.com/xuxingchen2018/ShortVideo-Android"
alias gitt="open https://github.com/xuxingchen2018/ShortVideo-Android"
alias mrcd="/Users/xuxingchen/mrcd"
alias cm="git commit -am"
alias apush="git pull main dev&&git push origin dev&&gita"
alias dir-script="/Users/xuxingchen/.ScriptLauncher"
alias dir-pay="/Users/xuxingchen/AndroidStudioProjects/MrcdPayment"
alias mygithub="/Users/xuxingchen/mygithub"
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
  git pull $@
  if [ "$?" = "0" ] && [ "$(pwd | grep "WeShare-Android")" != "" ]; then
    echo "pull" | nc localhost 12345
  fi
}
