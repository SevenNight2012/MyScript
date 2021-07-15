#!/usr/bin/env bash
# while read line; do
#   echo ">>>>$line"
# done <"$()"
# nc -lk localhost 12345 | while read line; do
#   echo "$line"
#   if [[ "$line" == "pull" ]]; then
#     result=$(bash test.sh $line)
#     echo -e "$result \n"
#   fi
# done
if [[ -p buffer ]]; then
  rm buffer
fi
mkfifo buffer
cat buffer|nc -lk localhost 12345 | while read line;do
  echo "Server 接收到: $line"
  if [[ "$line" == "pull" ]]; then
      bash test.sh $line
  fi
done >buffer
