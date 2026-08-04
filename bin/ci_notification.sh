#!/bin/bash
set -o pipefail

url=$(gh pr view | grep -o 'https://.*')

if [ -z "$url" ]; then
  echo "PRが見つかりません" >&2
  exit 1
fi

gh pr checks --watch | terminal-notifier -title "CIの実行が完了しました。" -message "$url" -open "$url"
