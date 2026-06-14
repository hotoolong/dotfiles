#!/usr/bin/env fish
# -*-  mode:fish; tab-width:4  -*-

function watch-ci --description 'PRのCI完了を待ち、結果に応じて音と通知で知らせる'
    # 引数でPR番号を指定。省略時は現在のブランチに紐づくPRを自動取得
    set -l pr $argv[1]
    if test -z "$pr"
        set pr (gh pr view --json number -q .number 2>/dev/null)
    end
    if test -z "$pr"
        echo "PR番号を特定できませんでした。引数で指定してください: watch-ci <PR番号>" >&2
        return 1
    end

    # 実行中のディレクトリ名を通知に含める
    set -l dir (basename $PWD)

    echo "PR #$pr のCI完了を待機中..."
    if gh pr checks $pr --watch --interval 30
        afplay /System/Library/Sounds/Glass.aiff 2>/dev/null &
        osascript -e "display notification \"✅ CI passed\" with title \"PR #$pr ($dir)\""
    else
        afplay /System/Library/Sounds/Basso.aiff 2>/dev/null &
        osascript -e "display notification \"❌ CI failed\" with title \"PR #$pr ($dir)\""
    end
end
