#!/bin/bash

url=$(gh pr view | grep -o 'https://.*')
gh pr checks --watch | terminal-notifier -title "CIの実行が完了しました。" -message "$url" -open "$url"
