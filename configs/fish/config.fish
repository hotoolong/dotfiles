set -x EDITOR /usr/local/bin/nvim
set -x NOTIFY_COMMAND_COMPLETE_TIMEOUT 10
set -lx TERM screen-256color-bce;
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
alias rails='bundle exec rails'
alias rspec='bundle exec rspec'

function dbup
  # echo したい
  ls -r db/migrate | fzf | sed 's/_.*//' | xargs -I{} ./bin/rails db:migrate:up VERSION={}
end

function dbdown
  # echo したい
  ls -r db/migrate | fzf | sed 's/_.*//' | xargs -I{} ./bin/rails db:migrate:down VERSION={}
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
alias gst 'git status'
alias gss 'git status -s'
alias ggpull 'git pull origin (git_current_branch)'
alias ggpush 'git push origin (git_current_branch)'
alias ggpushf 'git push --force-with-lease origin (git_current_branch)'

function is_git_dir
  git rev-parse --is-inside-work-tree > /dev/null 2>&1
end

function gg --description 'grep directory'
  if is_git_dir
    git grep --line-number --heading --break --show-function $argv
  else
    # grep -nr $argv .
    rg $argv
  end
end

function git_current_branch
  set -l ref (git symbolic-ref --quiet HEAD 2> /dev/null)
  set -l ret $status
  if [ $ret != 0 ]
    [ $ret == 128 ]; and return  # no git repo.
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
  gh issue list --state open | fzf --prompt='Open issue list >' --preview "gh issue view {1}" | cut -f1 | xargs -I{} gh issue view -w {}
end

function fzf_git_pull_request
  set -l query (commandline --current-buffer)
  if test -n $query
    set fzf_query --query "$query"
  end

  set -l out ( \
    gh pr list | \
    fzf $fzf_query \
      --prompt='Select Pull Request>' \
      --preview="gh pr view {1}" \
      --expect=ctrl-c \
      --header='enter: open in browser, checkout: ctrl-c' \
  )
  if test -z $out
    return
  end
  set -l pr_id (echo $out[2] | awk '{ print $1 }')
  if test $out[1] = 'ctrl-c'
    commandline "gh pr checkout $pr_id"
    commandline -f execute
  else
    commandline "gh pr view --web $pr_id"
    commandline -f execute
  end
end

function fzf_select_ghq_repository
  set -l query (commandline --current-buffer)
  if test -n $query
    set fzf_query --query "$query"
  end

  ghq list | \
    fzf $fzf_query \
      --prompt='Select Repository >' \
      --preview="echo {} | cut -d'/' -f 2- | xargs -I{} gh repo view {} " | \
    read -l line

  if test -n $line
    set -l dir_path (ghq list --full-path --exact $line)
    commandline "cd $dir_path"
    commandline -f execute
  end
end

function fzf-find-file
  find . -type f | fzf --prompt='Select files' | xargs -o /usr/local/bin/nvim
  commandline -f repaint
end

function fzf_select_history
  history | fzf | read -l line

  if [ $line ]
    commandline $line
  else
    commandline -f repaint
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
  standard_cd $argv; and ls
end

# reload

function reload
  exec fish
end

set -g fish_user_paths "/usr/local/sbin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/openssl/bin" $fish_user_paths
source /usr/local/opt/asdf/asdf.fish

status --is-interactive; and source (rbenv init -|psub)
