#!/bin/sh
# set x

create_daily_file() {
  if [ $# != 1 ]; then
    echo 引数エラー: "$@"
    exit 1
  else
    base_dir=$1
  fi

  extension=".txt"
  today_file=$(date -v-4H "+%Y%m%d${extension}")
  today_year=$(date -v-4H "+%Y")
  today_month=$(date -v-4H "+%m")

  cd "$base_dir" || exit

  if [ ! -d "./$today_year/$today_month/" ]; then
    mkdir -p "./$today_year/$today_month/"
  fi

  if [ ! -f "./$today_year/$today_month/$today_file" ]; then
    cp "$(find ./*/* -maxdepth 1 -type f -name "[0-9]*$extension" | sort -r | head -1)" "./$today_year/$today_month/$today_file"
  fi
  echo "./$today_year/$today_month/$today_file"
}
