#!/bin/bash

# PATH=/opt/homebrew/bin:/bin:/usr/bin:$PATH

from=$(date -u -v-5M +"%Y-%m-%dT%H:%M:%SZ")
to=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
count=`gh api notifications | jq --arg from $from --arg to $to '.[] | select(.updated_at >= $from and .updated_at <= $to)' | jq -s '.' | jq 'length'`

if (( count > 0 )); then
  osascript -e "display notification \"新しい通知 ${count}件\" with title \"GitHub\""
fi
