set -x EDITOR /usr/local/bin/nvim
set -x NOTIFY_COMMAND_COMPLETE_TIMEOUT 10
set -x TERM screen-256color-bce;
set -x GOPATH $HOME/gocode
set -x PATH $HOME/bin $GOPATH/bin $PATH
set -x PGDATA /usr/local/var/postgres
set -x NEXTWORD_DATA_PATH $HOME/nextword-data

alias ls='ls -la'
alias less='less -qR'

# vim
alias v='/usr/local/bin/nvim'
alias vi='/usr/local/bin/nvim'

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

  set -l out (ls -1 db/migrate | grep -v -e '^\.' | \
    fzf --exit-0 \
      --preview="bat --color=always db/migrate/{}" \
      --expect=ctrl-u,ctrl-d,ctrl-r,ctrl-m \
      --header='C-u: up, C-d: down, C-r: redo, C-m(Enter): edit' \
  )
  [ $status != 0 ] && commandline -f repaint && return

  if string length -q -- $out
    set -l key $out[1]
    set -l time (echo $out[2] | awk -F '_' '{ print $1 }')
    if test $key = 'ctrl-u'
      commandline "./bin/rails db:migrate:up VERSION=$time"
    else if test $key = 'ctrl-d'
      commandline "./bin/rails db:migrate:down VERSION=$time"
    else if test $key = 'ctrl-r'
      commandline "./bin/rails db:migrate:redo VERSION=$time"
    else if test $key = 'ctrl-m'
      commandline "$EDITOR db/migrate/$out[2]"
    end
    commandline -f execute
  end
end

# rake
alias rake='bundle exec rake'

# git
alias g='git'
alias ga 'git add'
alias gb 'git branch'
alias gc 'git commit -v'
alias gd 'git diff'
alias gco 'git checkout'
alias gcom 'git checkout master'
alias gdc 'git diff --cached'
alias ggpull 'git pull origin (git_current_branch)'
alias ggpush 'git push origin (git_current_branch)'
alias ggpushf 'git push --force-with-lease origin (git_current_branch)'

function is_git_dir
  git rev-parse --is-inside-work-tree > /dev/null 2>&1
end

function gst --description 'git status -s'
  if ! is_git_dir
    return
  end
  set -l base_command unbuffer git status -s
  set -l bind_reload "reload($base_command)"
  set -l bind_commands "ctrl-a:execute-silent(git add {2})+$bind_reload"
  set bind_commands $bind_commands "ctrl-u:execute-silent(git restore --staged {2})+$bind_reload"
  set -l bind_str (string join ',' $bind_commands)

  set -l out (command $base_command | \
    fzf --exit-0 --ansi \
    --preview="set -l git_status (echo {} | cut -c 1-2);[ \$git_status = '??' ] && bat --color=always {2} || [ \$git_status = 'M ' ] && unbuffer git diff --staged {2} || unbuffer git diff {2}" \
        --expect=ctrl-m,ctrl-r,ctrl-v,ctrl-c,ctrl-p \
        --bind $bind_str \
        --header='C-a: add, C-p: partial, C-u: unstage, C-c: commit, C-m(Enter): edit, C-r: rm, C-v: mv' \
  )
  [ $status != 0 ] && commandline -f repaint && return

  if string length -q -- $out
    set -l key $out[1]
    set -l file (echo $out[2] | awk -F ' ' '{ print $NF }')

    if test $key = 'ctrl-v'
      commandline -f repaint
      commandline "git mv $file "
    else if test $key = 'ctrl-r'
      commandline "git rm $file "
      commandline -f execute
    else if test $key = 'ctrl-m'
      commandline "$EDITOR $file"
      commandline -f execute
    else if test $key = 'ctrl-c'
      commandline "git commit -v"
      commandline -f execute
    else if test $key = 'ctrl-p'
      commandline "git add -p $file"
      commandline -f execute
    else
      commandline -f repaint
    end
  end
end

function gg --description 'Customizing file grep'
  set -l out ( \
    rg --vimgrep --color always $argv | \
        fzf --ansi --multi \
        --preview="set -l line (echo {1} | cut -d':' -f 2);set -l file (echo {1} | cut -d':' -f 1);bat --highlight-line \$line --line-range (if [ \$line -gt 10 ]; math \$line - 10;else; echo 0;end): --color=always \$file" \
  )
  [ $status != 0 ] && commandline -f repaint && return

  if test -n (count $out)
    set -l file_names
    for line in $out
      set file_names (echo $line | awk -F':' '{print $1}') $file_names
    end
    commandline "$EDITOR +/$argv $file_names"
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
  set bind_commands $bind_commands "ctrl-o:reload($base_command --state open)"
  set bind_commands $bind_commands "ctrl-c:reload($base_command --state closed)"
  set bind_commands $bind_commands "ctrl-g:reload($base_command --state merged)"
  set bind_commands $bind_commands "ctrl-a:reload($base_command --state all)"
  set -l bind_str (string join ',' $bind_commands)

  set -l out ( \
    command $base_command | \
    fzf $fzf_query \
        --prompt='Select Pull Request>' \
        --preview="gh pr view {1}" \
        --expect=ctrl-k,ctrl-m \
        --header='enter: open in browser, C-k: checkout, C-a: all, C-o: open, C-c: closed, C-g: merged, C-a: all' \
  )
  if test -z $out
    return
  end
  set -l pr_id (echo $out[2] | awk '{ print $1 }')
  if test $out[1] = 'ctrl-k'
    commandline "gh pr checkout $pr_id"
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

function fzf-find-file
  set -l query (commandline --current-buffer)

  set -l target_file (
    fd --type f --search-path . | \
    fzf --prompt='Select files > ' --query "$query" \
  )
  [ $status != 0 ] && commandline -f repaint && return
  if test -n $target_file
    commandline "$EDITOR $target_file"
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

# reload

function reload
  exec $SHELL
end

set -g fish_user_paths "/usr/local/sbin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/openssl/bin" $fish_user_paths
source /usr/local/opt/asdf/asdf.fish

status --is-interactive && source (rbenv init -|psub)
