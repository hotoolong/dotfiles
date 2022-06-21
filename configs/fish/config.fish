set -x NOTIFY_COMMAND_COMPLETE_TIMEOUT 10
set -x TERM screen-256color-bce;
set -x GOPATH $HOME/gocode
set -x PATH $HOME/bin $GOPATH/bin $PATH
set -x PGDATA /usr/local/var/postgres
set -x NEXTWORD_DATA_PATH $HOME/.nextword-data
set -x HOMEBREW_NO_AUTO_UPDATE 1
set -x BREW_PREFIX (brew --prefix)
set -x OPENSSL_DIR $BREW_PREFIX/opt/openssl@1.1
set -g fish_user_paths $BREW_PREFIX"/sbin" $OPENSSL_DIR"/bin" $fish_user_paths
set -x RUBY_CONFIGURE_OPTS --with-openssl-dir=$OPENSSL_DIR
source $BREW_PREFIX/opt/asdf/asdf.fish

# set EDITOR
if command -q nvim
  set -x EDITOR (which nvim)
else
  set -x EDITOR vim
end

function vi
  if command -q nvim
    if command -q node
      set -l local_nodejs_version (node -v | sed -e 's/v//')
      set -l global_nodejs_version (grep nodejs ~/.tool-versions | cut -d' ' -f 2)
      asdf shell nodejs $global_nodejs_version
      $EDITOR $argv
      asdf shell nodejs $local_nodejs_version
      return
    end
  end
  $EDITOR $argv
end

# ls
alias ls='ls -la'
alias less='less -qR'

# tree
alias tree "tree -NC" # N: 文字化け対策, C:色をつける

# rails
alias rspec='bundle exec rspec'
alias rails='bundle exec rails'

function migrate
  if test ! -d 'db/migrate'
    echo 'Go to Rails Root'
    return
  end

  set -l out ( \
     ./bin/rake db:migrate:status ^/dev/null | \
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
      commandline "./bin/rails db:migrate"
    else if test $key = 'ctrl-u'
      commandline "./bin/rails db:migrate:up VERSION=$time"
    else if test $key = 'ctrl-d'
      commandline "./bin/rails db:migrate:down VERSION=$time"
    else if test $key = 'ctrl-r'
      commandline "./bin/rails db:migrate:redo VERSION=$time"
    else if test $key = 'ctrl-m'
      set -l target_file (ls -1 ./db/migrate | grep $time)
      commandline "vi db/migrate/$target_file"
    end
    commandline -f execute
  end
end

# rake
alias rake='bundle exec rake'

# docker
alias d='docker'
alias dc='docker-compose'

# git
alias g='git'
alias ga 'git add'
alias gc 'git commit -v'
alias gd 'git diff'
alias gco 'git checkout'
alias gsw 'git switch'
alias gdc 'git diff --cached'
alias ggpull 'git pull origin (git_current_branch)'
alias ggpush 'git push origin (git_current_branch)'
alias ggpushf 'git push --force-with-lease origin (git_current_branch)'

function is_git_dir
  git rev-parse --is-inside-work-tree > /dev/null 2>&1
end

function git_main_branch --description 'git main branch'
  git remote show origin | grep 'HEAD branch' | awk '{print $NF}'
end

function gcom --description 'git switch <main branch>'
  git switch (git_main_branch)
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
      commandline "vi $file"
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
        --preview="set -l main (git_main_branch);[ {1} = '*' ] && git diff $main {2} || git diff $main {1}" \
  )
  [ $status != 0 ] && commandline -f repaint && return

  if test -n $out
    commandline "git switch $out"
    commandline -f execute
  end
end

function gg --description 'Customizing file grep'
  set -l out ( \
    rg --vimgrep --color always $argv | \
        fzf --ansi --multi \
        --preview="set -l line (echo {1} | cut -d':' -f 2);set -l file (echo {1} | cut -d':' -f 1);bat --highlight-line \$line --line-range (if [ \$line -gt 10 ]; math \$line - 10;else; echo 1;end): --color=always \$file" \
  )
  [ $status != 0 ] && commandline -f repaint && return

  if test -n (count $out)
    set -l line (echo $out | cut -d':' -f 2);
    set -l file (echo $out | cut -d':' -f 1);
    commandline "vi +$line $file -c 'let @/ = \"$argv\"'"
    commandline -f execute
  end
end

function gga --description "Costomizing file grep in all repositories"
  set -l out ( \
    rg --vimgrep --color always $argv (ghq root --all) | \
        fzf --ansi --multi \
        --preview="set -l line (echo {1} | cut -d':' -f 2);set -l file (echo {1} | cut -d':' -f 1);bat --highlight-line \$line --line-range (if [ \$line -gt 10 ]; math \$line - 10;else; echo 1;end): --color=always \$file" \
  )
  [ $status != 0 ] && commandline -f repaint && return
  if test -n (count $out)
    set -l file_names
    for line in $out
      set file_names (echo $line | awk -F':' '{print $1}') $file_names
    end
    commandline "vi +/$argv $file_names"
    commandline -f execute
  end
end

function git_current_branch
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

function fzf_git_issue
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

function fzf_git_pull_request
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
        --expect=ctrl-e,ctrl-m,ctrl-v \
        --header='enter: open in browser, C-e: checkout, C-v: approve , C-a: all, C-g: merged' \
  )
  [ $status != 0 ] && commandline -f repaint && return
  set -l pr_id (echo $out[2] | awk '{ print $1 }')
  if test $out[1] = 'ctrl-e'
    commandline "gh pr checkout $pr_id"
    commandline -f execute
  else if test $out[1] = 'ctrl-v'
    commandline "gh pr review $pr_id --approve"
    commandline -f execute
  else if test $out[1] = 'ctrl-m'
    commandline "gh pr view --web $pr_id"
    commandline -f execute
  end
end

function fzf_select_ghq_repository
  set -l query (commandline --current-buffer)
  if test -n $query
    set fzf_query --query "$query"
  end

  set -l out (
    for i in (ghq root -all)
      fd --type d --min-depth 2 --max-depth 4 --hidden --search-path $i '.git$' | \
      sed -e "s/\/.git\$//"
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

function trend_ruby_week
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

function fzf-find-file
  set -l query (commandline --current-buffer)

  set -l target_file (
    fd --type f --search-path . | \
    fzf --prompt='Select files > ' --query "$query" \
        --preview="bat --color=always {}" \
  )
  [ $status != 0 ] && commandline -f repaint && return
  if test -n $target_file
    commandline "vi $target_file"
    commandline -f execute
  end
end

function fzf_select_history
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
      --preview="git diff master {3} " | \
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
      --expect=ctrl-d,ctrl-m,ctrl-v,ctrl-s \
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

bind \cr 'fzf_select_history (commandline --current-buffer)'
bind \cs fzf-find-file
bind \cg\cl fzf-git-recent-all-branches
bind \cg\cr fzf_select_ghq_repository
bind \cg\ci fzf_git_issue
bind \cg\cp fzf_git_pull_request

# abbr

abbr today date "+%Y%m%d%H%M%S"

# cd

functions --copy cd standard_cd

function cd
  standard_cd $argv && ls
end

# function prompt_pwd --description
function prompt_pwd --description "Print the current working directory, shortened to fit the prompt"
  set -l options h/help
  argparse -n prompt_pwd --max-args=0 $options -- $argv
  or return

  if set -q _flag_help
    __fish_print_help prompt_pwd
    return 0
  end

  # This allows overriding fish_prompt_pwd_dir_length from the outside (global or universal) without leaking it
  set -q fish_prompt_pwd_dir_length
  or set -l fish_prompt_pwd_dir_length 1

  # Replace $HOME with "~"
  set -l realhome ~
  set -l tmp (string replace -r '^'"$realhome"'($|/)' '~$1' $PWD)

  if [ $fish_prompt_pwd_dir_length -eq 0 ]
    echo $tmp
  else
    set -q fish_prompt_dir_full_name_range
    or set -l fish_prompt_dir_full_name_range 2
    if [ $fish_prompt_dir_full_name_range -le 0 ]
      set fish_prompt_dir_full_name_range 1
    end
    set -l folders (string split -rm$fish_prompt_dir_full_name_range / $tmp)
    # Shorten to at most $fish_prompt_pwd_dir_length characters per directory
    echo (string replace -ar '(\.?[^/]{'"$fish_prompt_pwd_dir_length"'})[^/]*/' '$1/' $folders[1]'/')(string join / $folders[2..-1])
  end
end

# reload

function reload
  exec $SHELL
end

status --is-interactive && source (rbenv init -|psub)
direnv hook fish | source
zoxide init fish | source
