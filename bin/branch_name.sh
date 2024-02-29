#!/bin/bash

# 引数の数をチェック
if [ "$#" -eq 0 ]; then
  echo "引数が指定されていません。"
  exit 1
fi

words=$(echo "$*" | tr ' ' '_')
first_char=$(echo "${words:0:1}" | tr '[:upper:]' '[:lower:]')
rest_of_char="${words:1}"
echo "${first_char}${rest_of_char}"
