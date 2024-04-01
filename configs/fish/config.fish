set -gx NOTIFY_COMMAND_COMPLETE_TIMEOUT 10
set -gx TERM screen-256color-bce;
set -gx GOPATH $HOME/gocode
set -gx PGDATA /usr/local/var/postgres
set -gx NEXTWORD_DATA_PATH $HOME/.nextword-data
set -gx HOMEBREW_NO_AUTO_UPDATE 1
set -gx BREW_PREFIX (brew --prefix)
set -gx OPENSSL_DIR $BREW_PREFIX/opt/openssl@3
set -gx RUBY_CONFIGURE_OPTS --with-openssl-dir=$OPENSSL_DIR
set -gx TMUX_SHELL (which fish)
set -gx fish_prompt_pwd_full_dirs 2
fish_add_path $BREW_PREFIX/bin
fish_add_path $BREW_PREFIX/sbin
fish_add_path $OPENSSL_DIR/bin
fish_add_path $GOPATH/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/bin
fish_add_path $BREW_PREFIX/opt/gawk/libexec/gnubin

if not functions -q fundle; eval (curl -sfL https://git.io/fundle-install); end

# fundle setting
fundle plugin 'edc/bass'
fundle plugin 'tuvistavie/fish-asdf'
fundle plugin 'jethrokuan/z'
fundle init

# set EDITOR
if command -q nvim
  set -gx EDITOR (which nvim)
else
  set -gx EDITOR vim
end

if command -q asdf
  source $BREW_PREFIX/opt/asdf/libexec/asdf.fish
  source $BREW_PREFIX/opt/asdf/share/fish/vendor_completions.d/asdf.fish

  if command -q python
    fish_add_path (asdf where python)/bin
  end
end

function vi
  if string match -r : $argv[-1] > /dev/null 2>&1
    set -l file_and_line (string split -r -m1 : $argv[-1])
    if test (count $file_and_line) -eq 2
      $EDITOR $argv[1..-2] +$file_and_line[2] $file_and_line[1]
    end
  else
    $EDITOR $argv
  end
end

# alias
alias ls 'ls -la'
alias less 'less -qR'
alias tree "tree -NC" # N: 文字化け対策, C:色をつける
alias be 'bundle exec'
alias rspec 'bundle exec rspec'
alias rails 'bundle exec rails'
alias railsc 'bundle exec rails c'
alias tf 'terraform'
alias tfmt 'terraform fmt -recursive'

function migrate
  if test ! -d 'db/migrate'
    echo 'Go to Rails Root'
    return
  end

  set -l out ( \
     bundle exec rails db:migrate:status 2>/dev/null | \
     tail -n +6 | \
     sed '/^$/d' | \
     fzf --exit-0 \
       --tac \
       --preview="bat --color=always ./db/migrate/(ls -1 ./db/migrate | grep {2})" \
       --expect=ctrl-a,ctrl-u,ctrl-d,ctrl-r,ctrl-m \
       --header='C-a: all, C-u: up, C-d: down, C-r: redo, C-m(Enter): edit' \
    )
  [ $status != 0 ] && commandline -f repaint && return

  if string length -q -- $out
    set -l key $out[1]
    set -l time (echo $out[2] | awk -F ' ' '{ print $2 }')
    if test $key = 'ctrl-a'
      commandline "bundle exec rails db:migrate"
    else if test $key = 'ctrl-u'
      commandline "bundle exec rails db:migrate:up VERSION=$time"
    else if test $key = 'ctrl-d'
      commandline "bundle exec rails db:migrate:down VERSION=$time"
    else if test $key = 'ctrl-r'
      commandline "bundle exec rails db:migrate:redo VERSION=$time"
    else if test $key = 'ctrl-m'
      set -l target_file (ls -1 ./db/migrate | grep $time)
      commandline "$EDITOR db/migrate/$target_file"
    end
    commandline -f execute
  end
end

function kill_all_spring
  ps aux | grep 'spring ' | grep -v grep | awk '{ print $2 }' | xargs kill -9
end

# rake
alias rake 'bundle exec rake'

# docker
alias d 'docker'
alias dc 'docker compose'

# git
alias g 'git'
alias ga 'git add'
alias gc 'git commit -v'
alias gd 'git diff'
alias gdm 'git diff --merge-base (git-default-branch)'
alias gco 'git checkout'
alias gsw 'git switch'
alias gdc 'git diff --cached'
alias ggpull 'git pull origin (git-current-branch)'
alias ggpush 'git push origin (git-current-branch)'
alias ggpushf 'git push --force-with-lease --force-if-includes origin (git-current-branch)'

abbr ghp 'gh pr view'
abbr ghi 'gh issue view'

function is_git_dir
  git rev-parse --is-inside-work-tree > /dev/null 2>&1
end

function git-default-branch --description 'get git default branch'
  if ! is_git_dir
    return
  end
  set -l branch (gh repo view --json "defaultBranchRef" --jq ".defaultBranchRef.name" 2>/dev/null)
  if test $status -eq 0
    echo $branch
    return
  end
  set branch (git remote show origin 2>/dev/null)
  if test $status -eq 0
    echo $branch | grep 'HEAD branch' | awk '{print $NF}'
    return
  end
  git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'
end

function gcom --description 'git switch <default branch>'
  git switch (git-default-branch)
end

function grm --description 'git rebase <default branch>'
  git rebase (git-default-branch)
end

function gst --description 'git status -s'
  if ! is_git_dir
    return
  end
  set -l base_command
  if command -q unbuffer
    set base_command unbuffer git status -s
  else
    set base_command git status -s
  end
  set -l bind_reload "reload($base_command)"
  set -l bind_commands "ctrl-a:execute-silent(git add {2})+$bind_reload"
  set bind_commands $bind_commands "ctrl-u:execute-silent(git restore --staged {2})+$bind_reload"
  set bind_commands $bind_commands "ctrl-r:execute-silent([ -z (git ls-files --others --exclude-standard {2}) ] && git rm {2} || rm {2})+$bind_reload"
  set bind_commands $bind_commands "ctrl-o:execute-silent(git restore {2})+$bind_reload"
  set -l bind_str (string join ',' $bind_commands)

  set -l out (command $base_command | \
    fzf --exit-0 --ansi \
    --preview="set -l git_status (echo {} | cut -c 1-2);[ \$git_status = '??' ] && bat --color=always {2} || [ \$git_status = 'M ' -o \$git_status = 'A ' ] && git diff --color --staged {2} || git diff --color {2}" \
        --expect=ctrl-m,ctrl-v,ctrl-c,ctrl-p,ctrl-d \
        --bind $bind_str \
        --header='C-a: add, C-p: partial, C-u: unstage, C-c: commit, C-m(Enter): edit, C-r: rm, C-v: mv, C-d: diff, C-o: restore' \
  )
  [ $status != 0 ] && commandline -f repaint && return

  if string length -q -- $out
    set -l key $out[1]
    set -l file (echo $out[2] | awk -F ' ' '{ print $NF }')

    if test $key = 'ctrl-v'
      commandline -f repaint
      commandline "git mv $file "
    else if test $key = 'ctrl-m'
      commandline "$EDITOR $file"
      commandline -f execute
    else if test $key = 'ctrl-c'
      commandline "git commit -v"
      commandline -f execute
    else if test $key = 'ctrl-p'
      commandline "git add -p $file"
      commandline -f execute
    else if test $key = 'ctrl-d'
      set -l state (echo $out[2] | cut -c 1-2)
      if [ $state = 'M ' -o $state = 'A ' ]
        commandline "git diff --staged $file"
      else
        commandline "git diff $file"
      end
      commandline -f execute
    else
      commandline -f repaint
    end
  end
end

function commit --description 'git commit -m'
  command git commit -m "$argv"
end

function gb --description 'git branch'
  set -l query (commandline --current-buffer)
  if test -n $query
    set fzf_query --query "$query"
  end

  set -l out ( \
    git branch | \
      fzf $fzf_query \
        --prompt='Select Branch >' \
        --header='C-d: delete, Enter: switch, Tab: choice' \
        --expect=ctrl-m,ctrl-d \
        --multi \
        --preview="[ {1} = '*' ] && git diff --color (git merge-base (git-default-branch) {2})..{2} || git diff --color (git merge-base (git-default-branch) {1})..{1}" \
  )
  [ $status != 0 ] && commandline -f repaint && return

  if string length -q -- $out
    set -l key $out[1]
    if test $key = 'ctrl-d'
      for select_data in $out[2..-1]
        set -l branch_name (echo $select_data | sed -e 's/^[ \*]*//g')
        git branch -D $branch_name
      end
    else if test $key = 'ctrl-m'
      set -l branch_name (echo $out[2] | sed -e 's/^[ \*]*//g')
      commandline "git switch $branch_name"
      commandline -f execute
    end
  end
end

function gg --description 'Customizing file grep'
  set -l options t/text
  argparse -n gg $options -- $argv
  or return

  if set -lq _flag_text
    rg --glob '!.git/' --hidden --vimgrep --color always $argv
    return
  end

  set -l out ( \
    rg --glob '!.git/' --hidden --vimgrep --color always $argv | \
        fzf --ansi --multi \
        --preview="set -l line (echo {1} | cut -d':' -f 2);set -l file (echo {1} | cut -d':' -f 1);bat --highlight-line \$line --line-range (if [ \$line -gt 10 ]; math \$line - 10;else; echo 1;end): --color=always \$file" \
  )
  [ $status != 0 ] && commandline -f repaint && return

  if test -n (count $out)
    set -l line (echo $out | cut -d':' -f 2)
    set -l file (echo $out | cut -d':' -f 1)
    commandline "$EDITOR +$line $file -c 'let @/ = \"$argv[1]\"'"
    commandline -f execute
  end
end

function gga --description "Costomizing file grep in all repositories"
  set -l options t/text
  argparse -n gga $options -- $argv
  or return

  gg $argv[1] (ghq root --all)
end

function git-current-branch
  set -l ref (git symbolic-ref --quiet HEAD 2> /dev/null)
  set -l ret $status
  if [ $ret != 0 ]
    [ $ret == 128 ] &&  return  # no git repo.
    set -l ref (git rev-parse --short HEAD 2> /dev/null); or return
  end
  string replace 'refs/heads/' "" $ref
end

function gsel --description 'git pull origin $(branch)'
  echo (git status -s | head -n $argv[1] | tail -n 1 | awk '{print $2}')
end

function gdd --description 'git pull origin $(branch)'
  set file_name (git status -s | head -n $argv[1] | tail -n 1 | awk '{print $2}')
  echo (gd $file_name)
end

# fzf

function fzf-github-issue
  set -l query (commandline --current-buffer)
  if test -n $query
    set fzf_query --query "$query"
  end

  set -l base_command gh issue list --limit 100
  set -l bind_commands "ctrl-a:reload($base_command --state all)"
  set bind_commands $bind_commands "ctrl-o:reload($base_command --state open)"
  set bind_commands $bind_commands "ctrl-c:reload($base_command --state closed)"
  set -l bind_str (string join ',' $bind_commands)

  set -l out ( \
    command $base_command | \
    fzf $fzf_query \
        --prompt='Open issue list >' \
        --preview "gh issue view {1}" \
        --bind $bind_str \
        --header='C-a: all, C-o: open, C-c: closed' \
  )
  if test -z $out
    return
  end
  set -l issue_id (echo $out | awk '{ print $1 }')
  commandline "gh issue view -w $issue_id"
  commandline -f execute
end

function fzf-github-pull-request
  set -l query (commandline --current-buffer)
  if test -n $query
    set fzf_query --query "$query"
  end

  set -l base_command gh pr list --limit 100
  set -l bind_commands "ctrl-a:reload($base_command --state all)"
  set bind_commands $bind_commands "ctrl-g:reload($base_command --state merged)"
  set -l bind_str (string join ',' $bind_commands)

  set -l out ( \
    command $base_command | \
    fzf $fzf_query \
        --prompt='Select Pull Request>' \
        --preview="gh pr view {1}" \
        --expect=ctrl-w,ctrl-e,ctrl-m,ctrl-v,ctrl-d \
        --bind $bind_str \
        --header='enter: view, C-w: open in browser, C-e: checkout, C-d: diff, C-v: approve , C-a: all, C-g: merged' \
  )
  [ $status != 0 ] && commandline -f repaint && return
  set -l pr_id (echo $out[2] | awk '{ print $1 }')
  if test $out[1] = 'ctrl-e'
    commandline "gh pr checkout $pr_id"
    commandline -f execute
  else if test $out[1] = 'ctrl-v'
    commandline "gh pr review $pr_id --approve"
    commandline -f execute
  else if test $out[1] = 'ctrl-w'
    commandline "gh pr view --web $pr_id"
    commandline -f execute
  else if test $out[1] = 'ctrl-d'
    commandline "gh pr diff $pr_id"
    commandline -f execute
  else if test $out[1] = 'ctrl-m'
    commandline "gh pr view -c $pr_id"
    commandline -f execute
  end
end

function fzf-select-ghq-repository
  set -l query (commandline --current-buffer)
  if test -n $query
    set fzf_query --query "$query"
  end

  set -l out (
    for i in (ghq root -all)
      fd --type d --min-depth 2 --max-depth 4 --hidden --no-ignore --search-path $i '.git$' | \
      sed -e "s/\/.git\/\$//"
    end | \
    fzf $fzf_query \
      --prompt='Select Repository >' \
      --preview="echo {} | awk -F'/' '{ print \$(NF-1)\"/\"\$NF}' | \
    xargs -I{} gh repo view {}"
  )
  [ $status != 0 ] && commandline -f repaint && return

  if test -n $out
    commandline "cd $out"
    commandline -f execute
  end
end

function trend-ruby-week
  if test -n $query
    set fzf_query --query "$query"
  end

  set -l out (
    git trend -l ruby -s week | tail -n +3 | \
    fzf $fzf_query \
      --no-sort \
      --ansi \
      --prompt='Select Repository >' \
      --preview="gh repo view {2}"
  )
  [ $status != 0 ] && commandline -f repaint && return

  if test -n $out
    set -l repo (echo $out | awk '{ print $2 }')
    commandline "gh repo view -w $repo"
    commandline -f execute
  end
end

function ruby-all-version-execute
  for v in (rbenv versions | sed -e 's/^[ \*]*//g' | awk '{print $1}')
    echo "Ruby version: $v"
    RBENV_VERSION=$v $argv
  end
end

function fzf-find-file
  set -l query (commandline --current-buffer)

  set -l target_file (
    fd --type f --search-path . | \
    fzf --prompt='Select files > ' --query "$query" \
        --preview="bat --color=always {}" \
  )
  [ $status != 0 ] && commandline -f repaint && return
  if test -n $target_file
    commandline "$EDITOR $target_file"
    commandline -f execute
  end
end

function fzf-select-history
  set -l query (commandline --current-buffer)
  history | fzf --query "$query" | read -l line

  if [ $line ]
    commandline $line
  end
end

function fzf-git-recent-all-branches
  set -l query (commandline --current-buffer)
  if test -n $query
    set fzf_query --query "$query"
  end

  git for-each-ref --sort=creatordate | \
    fzf $fzf_query \
      --prompt='Select Branch >' \
      --preview="git diff (git-default-branch) {3} " | \
    read -l selected_branch

  if test -n $selected_branch
    commandline "git checkout $selected_branch"
    commandline -f execute
  end
  commandline -f repaint
end

function fzf-git-stash
  if ! is_git_dir
    return
  end

  set -l out (
    git stash list | \
    fzf --exit-0 \
      --ansi \
      --no-sort \
      --expect=ctrl-a,ctrl-d,ctrl-m,ctrl-s \
      --preview="echo {} | cut -d':' -f1 | xargs git stash show -p --color=always" \
      --header='C-a: apply C-d: drop, C-m(Enter): pop, C-s: show'
  )
  [ $status != 0 ] && commandline -f repaint && return

  if test -n $out[1]
    set -l stash_num (echo $out[2] | cut -d ':' -f 1)
    echo $stash_num
    switch $out[1]
    case 'ctrl-a'
      commandline "git stash apply $stash_num"
      commandline -f execute
    case 'ctrl-d'
      commandline "git stash drop $stash_num"
      commandline -f execute
    case 'ctrl-m'
      commandline "git stash pop $stash_num"
      commandline -f execute
    case 'ctrl-s'
      commandline "git stash show -p --color=always $stash_num"
      commandline -f execute
    end
  end
end
alias stash=fzf-git-stash

# bind

bind \cr 'fzf-select-history (commandline --current-buffer)'
bind \cs fzf-find-file
bind \cg\cl fzf-git-recent-all-branches
bind \cg\cr fzf-select-ghq-repository
bind \cg\ci fzf-github-issue
bind \cg\cp fzf-github-pull-request

# abbr

abbr today date "+%Y%m%d%H%M%S"

# cd

functions --copy cd standard_cd

function cd
  standard_cd $argv && ls
end

# reload

function reload
  exec $SHELL
end

eval (gh completion -s fish| source)
status --is-interactive && source (rbenv init -|psub)
direnv hook fish | source
zoxide init fish | source
