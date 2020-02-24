set -x EDITOR /usr/local/bin/nvim
set -x NOTIFY_COMMAND_COMPLETE_TIMEOUT 10
set -lx TERM screen-256color-bce;
set -x GOPATH $HOME/gocode
set -x PATH $HOME/bin $GOPATH/bin $PATH
set -x PGDATA /usr/local/var/postgres

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
  ls -r db/migrate | peco | sed 's/_.*//' | xargs -I{} ./bin/rails db:migrate:up VERSION={}
end

function dbdown
  # echo したい
  ls -r db/migrate | peco | sed 's/_.*//' | xargs -I{} ./bin/rails db:migrate:down VERSION={}
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
  gh issue list --state open | fzf --prompt='Open issue list >' --preview "gh issue view -p {1}" | cut -f1 | xargs -I{} gh issue view {}
end

function fzf_select_ghq_repository
  set -l query (commandline)

  if test -n $query
    set peco_flags --query "$query"
  end

  ghq list --full-path | fzf --prompt='Select Repository >' | read line

  if [ $line ]
    cd $line
    commandline -f repaint
  end
end

function fzf-find-file
  find . -type f | fzf --prompt='Select files' | xargs -o /usr/local/bin/nvim
  commandline -f repaint
end

function fzf_select_history
  history | fzf | read line

  if [ $line ]
    commandline $line
  else
    commandline ''
  end
end

# peco

function peco
  command peco --layout=bottom-up $argv
end

function peco_select_ghq_repository
  set -l query (commandline)

  if test -n $query
    set peco_flags --query "$query"
  end

  ghq list --full-path | peco $peco_flags | read line

  if [ $line ]
    cd $line
    commandline -f repaint
  end
end

function peco-find-file
  if is_git_dir
    # git ls-files | peco | xargs -I{} fish -c 'vi -p {} < /dev/tty'
    git ls-files | peco | xargs -o /usr/local/bin/nvim
  else
    # find . -type f | peco | xargs -I{} fish -c 'vi -p {} < /dev/tty'
    find . -type f | peco | xargs -o /usr/local/bin/nvim
  end
  commandline -f repaint
end

function peco-git-recent-all-branches
  if is_git_dir
    git for-each-ref --format='%(refname)' --sort=-committerdate refs/heads | perl -pne 's{^refs/heads/}{}' | peco | read selected_branch
    if [ -n "$selected_branch" ]
      git checkout $selected_branch
    end
  else
    echo 'not found git repo'
  end
  commandline -f repaint
end

# bind
bind \cr 'fzf_select_history (commandline -b)'
bind \cs fzf-find-file
bind \cg\cb peco-git-recent-all-branches
bind \cg\cr fzf_select_ghq_repository
bind \cg\ci fzf_git_issue

# cd

functions --copy cd standard_cd

function cd
  standard_cd $argv; and ls
end

# reload

function reload
  exec fish
end

set -g fish_user_paths "/usr/local/opt/openssl/bin" $fish_user_paths
