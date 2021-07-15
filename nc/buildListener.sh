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
nc -lk localhost 12345
