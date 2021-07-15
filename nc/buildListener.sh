#!/usr/bin/env bash
# while read line; do
#   echo ">>>>$line"
# done <"$()"
nc -lk localhost 12345 | while read line; do
  echo "$line"
  if [[ "$line" == "pull" ]]; then
    bash invoke.sh $line | cat
  fi
done
