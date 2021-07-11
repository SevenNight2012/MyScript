#!/usr/bin/env bash
# 通过系统random生成随机数，还有一种通过时间生成，在mac系统不太适用
function rand(){
    min=$1
    max=$(($2-$min+1))
    num=$(($RANDOM+1000000000)) #增加一个10位的数再求余
    echo $(($num%$max+$min))
}
