#!/bin/bash

threshold=90
process_info=$(ps aux -r | awk 'NR==2 {print $11,$3}')
process_name=$(echo "$process_info" | awk '{print $1}')
cpu_usage=$(echo "$process_info" | awk '{print int($2)}')

# 閾値を超えた場合に通知を表示
if [ "$cpu_usage" -gt "$threshold" ]; then
    osascript -e 'display notification "High CPU Usage: '$process_name' ('"$cpu_usage"'%)" with title "Alert"'
fi
