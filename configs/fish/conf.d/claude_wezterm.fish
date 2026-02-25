# Claude Code 終了後に WezTerm のユーザー変数をクリアする
# claude コマンド終了時のみ claude_status をリセットし、タブ色・分割線色を通常に戻す
function __clear_claude_status --on-event fish_postexec
  test "$TERM_PROGRAM" = WezTerm; or return
  switch "$argv"
    case 'claude *' claude
      printf '\033]1337;SetUserVar=%s=%s\007' claude_status ''
  end
end
