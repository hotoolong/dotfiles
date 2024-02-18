#!/bin/bash

# 引数の数をチェック
if [ "$#" -eq 0 ]; then
  echo "引数が指定されていません。"
  exit 1
fi

echo "$*" | tr ' ' '_'
