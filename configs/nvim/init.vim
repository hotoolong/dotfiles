if &compatible
  set nocompatible
endif
" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'tpope/vim-sensible'
Plug 'junegunn/seoul256.vim'

" file finder
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-git-status.vim'
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/glyph-palette.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'ryanoasis/vim-devicons'

Plug 'rhysd/git-messenger.vim'
Plug 'rhysd/conflict-marker.vim'

" snippet
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" ruby rails
Plug 'vim-ruby/vim-ruby'
Plug 'noprompt/vim-yardoc'
Plug 'tpope/vim-rails'
Plug 'slim-template/vim-slim'
Plug 'tomtom/tcomment_vim'

" markdown
Plug 'mattn/vim-maketable'

" html
Plug 'mattn/emmet-vim'
Plug 'othree/html5.vim'

" vue
Plug 'posva/vim-vue'
Plug 'Shougo/context_filetype.vim'

" node
Plug 'moll/vim-node'
Plug 'mattn/jscomplete-vim'
Plug 'myhere/vim-nodejs-complete'
Plug 'pangloss/vim-javascript'

" ctags
Plug 'majutsushi/tagbar'
Plug 'pechorin/any-jump.vim'

" シンタックスチェック
Plug 'dense-analysis/ale'
Plug 'delphinus/lightline-delphinus'
Plug 'itchyny/lightline.vim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'gregsexton/gitv'
Plug 'airblade/vim-gitgutter'
Plug 'iberianpig/tig-explorer.vim'
Plug 'rbgrouleff/bclose.vim'

" fzf preview
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/remote', 'do': ':UpdateRemotePlugins' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" colorscheme
Plug 'jacoborus/tender.vim'

" line number
Plug 'jeffkreeftmeijer/vim-numbertoggle'

" operator and textobject oprator
Plug 'machakann/vim-sandwich'
Plug 'terryma/vim-expand-region'

" fish
Plug 'dag/vim-fish'

" reference
Plug 'rizzatti/dash.vim'
Plug 'thinca/vim-ref'

" etc
Plug 'thinca/vim-quickrun'
Plug 'lambdalisue/vim-quickrun-neovim-job'
Plug 'sheerun/vim-polyglot'
Plug 'hotoolong/translate.nvim'
Plug 'AndrewRadev/switch.vim'
Plug 'lambdalisue/pastefix.vim'
Plug 'simeji/winresizer'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" Load Event
function! s:load_plug(timer)
    call plug#load(
                \ 'vim-ruby',
                \ 'vim-rails',
                \ 'vim-slim',
                \ 'tcomment_vim',
                \ )
endfunction

" Heavy plug-ins will be loaded later.
call timer_start(500, function("s:load_plug"))

filetype plugin indent on
syntax enable

let mapleader = "\<Space>"

" lambdalisue/fern.vim {{{
nnoremap <silent> td :<C-u>Fern . -drawer -reveal=%<CR>
let g:fern#renderer = "nerdfont"

augroup my-glyph-palette
  autocmd! *
  autocmd FileType fern call glyph_palette#apply()
  autocmd FileType nerdtree,startify call glyph_palette#apply()
augroup END

function! s:init_fern() abort
  " Use 'select' instead of 'edit' for default 'open' action
  set nonumber
  nmap <buffer> o <Plug>(fern-action-open:edit)
  nmap <buffer> go <Plug>(fern-action-open:edit)<C-w>p
  nmap <buffer> t <Plug>(fern-action-open:tabedit)
  nmap <buffer> T <Plug>(fern-action-open:tabedit)gT
  nmap <buffer> i <Plug>(fern-action-open:split)
  nmap <buffer> gi <Plug>(fern-action-open:split)<C-w>p
  nmap <buffer> s <Plug>(fern-action-open:vsplit)
  nmap <buffer> gs <Plug>(fern-action-open:vsplit)<C-w>p
  nmap <buffer> ma <Plug>(fern-action-new-path)
  nmap <buffer> P gg

  nmap <buffer> C <Plug>(fern-action-enter)
  nmap <buffer> u <Plug>(fern-action-leave)
  nmap <buffer> r <Plug>(fern-action-reload)
  nmap <buffer> R gg<Plug>(fern-action-reload)<C-o>
  nmap <buffer> cd <Plug>(fern-action-cd)
  nmap <buffer> CD gg<Plug>(fern-action-cd)<C-o>

  nmap <buffer> I <Plug>(fern-action-hidden-toggle)

  nmap <buffer> q :<C-u>quit<CR>
  nmap <buffer> <C-l> <C-w><C-w>

  nmap <buffer> <Plug>(fern-action-open) <Plug>(fern-action-open:select)
endfunction

augroup fern-custom
  autocmd! *
  autocmd FileType fern call s:init_fern()
augroup END

augroup my-fern-startup
  autocmd! *
  autocmd VimEnter * ++nested Fern . -drawer -reveal=% -stay
augroup END
" }}}

" hotoolong/translate.nvim {{{
let g:translate_copy_result = 1
" }}}

" simeji/winresizer {{{
let g:winresizer_start_key = '<C-z>'
" }}}

" tpope/vim-fugitive {{{
autocmd BufWritePost *
      \ if exists('b:git_dir') && executable(b:git_dir.'/hooks/create_tags') |
      \   call system('"'.b:git_dir.'/hooks/create_ctags" &') |
      \ endif
" }}}

" AndrewRadev/switch.vim {{{
nnoremap <silent><C-c> :<C-u>Switch<CR>
autocmd FileType eruby let b:switch_custom_definitions =
    \ [
    \   {
    \     ':\(\k\+\)\s\+=>': '\1:',
    \     '\<\(\k\+\):':     ':\1 =>',
    \   },
    \ ]
" }}}

" yuki-ycino/fzf-preview.vim {{{
let g:fzf_preview_if_binary_command   = "test (file -b --mime-encoding {3}) = 'binary'"
let g:fzf_binary_preview_command      = 'echo "{3} is a binary file"'
let g:fzf_preview_git_files_command   = 'git ls-files --exclude-standard | while read line; do if [[ ! -L $line ]] && [[ -f $line ]]; then echo $line; fi; done'
let g:fzf_preview_grep_cmd            = 'rg --line-number --no-heading --color=never --sort=path'
let g:fzf_preview_mru_limit           = 500
let g:fzf_preview_use_dev_icons       = 1
let g:fzf_preview_default_fzf_options = {
\ '--reverse': v:true,
\ '--preview-window': 'wrap',
\ '--exact': v:true,
\ '--no-sort': v:true,
\ }

if !exists('g:fzf_preview_command')
  if executable('bat')
    let g:fzf_preview_command = 'bat --color=always --plain {-1}'
  else
    let g:fzf_preview_command = 'head -100 {-1}'
  endif
endif
let g:fzf_preview_git_status_preview_command = "test -z (git diff --cached -- {-1}) && git diff --cached --color=always -- {-1} || " .
\ "test -z (git diff -- {-1}) && git diff --color=always -- {-1} || " .
\ g:fzf_preview_command
let $FZF_PREVIEW_PREVIEW_BAT_THEME  = 'gruvbox-dark'


noremap <fzf-p> <Nop>
map , <fzf-p>

nnoremap <silent> <fzf-p>r     :<C-u>CocCommand fzf-preview.FromResources buffer project_mru<CR>
nnoremap <silent> <fzf-p>w     :<C-u>CocCommand fzf-preview.ProjectMrwFiles<CR>
nnoremap <silent> <fzf-p>a     :<C-u>CocCommand fzf-preview.FromResources project_mru git<CR>
" nnoremap <silent> <fzf-p>g     :<C-u>CocCommand fzf-preview.GitActions<CR>
nnoremap <silent> <fzf-p>s     :<C-u>CocCommand fzf-preview.GitStatus<CR>
nnoremap <silent> <fzf-p>b     :<C-u>CocCommand fzf-preview.Buffers<CR>
nnoremap <silent> <fzf-p>B     :<C-u>CocCommand fzf-preview.AllBuffers<CR>
nnoremap <silent> <fzf-p><C-o> :<C-u>CocCommand fzf-preview.Jumps<CR>
nnoremap <silent> <fzf-p>/     :<C-u>CocCommand fzf-preview.Lines --resume --add-fzf-arg=--no-sort<CR>
" nnoremap <silent> <fzf-p>*     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="<C-r>=expand('<cword>')<CR>"<CR>
" xnoremap <silent> <fzf-p>*     "sy:CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="<C-r>=substitute(@s, '\(^\\v\)\\|\\\(<\\|>\)', '', 'g')<CR>"<CR>
" nnoremap <silent> <fzf-p>n     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="<C-r>=substitute(@/, '\(^\\v\)\\|\\\(<\\|>\)', '', 'g')<CR>"<CR>
" nnoremap <silent> <fzf-p>?     :<C-u>CocCommand fzf-preview.BufferLines --resume --add-fzf-arg=--no-sort<CR>
" nnoremap          <fzf-p>f     :<C-u>CocCommand fzf-preview.ProjectGrep<Space>
" xnoremap          <fzf-p>f     "sy:CocCommand fzf-preview.ProjectGrep<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"
nnoremap <silent> <fzf-p>q     :<C-u>CocCommand fzf-preview.QuickFix<CR>
nnoremap <silent> <fzf-p>l     :<C-u>CocCommand fzf-preview.LocationList<CR>
nnoremap <silent> <fzf-p>:     :<C-u>CocCommand fzf-preview.CommandPalette<CR>
nnoremap <silent> <fzf-p>p     :<C-u>CocCommand fzf-preview.Yankround<CR>
nnoremap <silent> <fzf-p>m     :<C-u>CocCommand fzf-preview.Bookmarks --resume<CR>
" nnoremap <silent> <fzf-p><C-]> :<C-u>CocCommand fzf-preview.VistaCtags --add-fzf-arg=--query="<C-r>=expand('<cword>')<CR>"<CR>
nnoremap <silent> <fzf-p>o     :<C-u>CocCommand fzf-preview.VistaBufferCtags<CR>
" nnoremap <silent> <fzf-p>g     :<C-u>FzfPreviewProjectGrep --add-fzf-arg=--nth=3<Space>
nnoremap <silent> <fzf-p>G     :<C-u>CocCommand fzf-preview.ProjectGrepRecall<CR>
nnoremap <silent> <fzf-p>g     :<C-u>CocCommand fzf-preview.ProjectGrep<Space>
nnoremap <silent> <fzf-p>f     :<C-u>CocCommand fzf-preview.ProjectFiles<CR>

" nnoremap <silent> <dev>q  :<C-u>CocCommand fzf-preview.CocCurrentDiagnostics<CR>
" nnoremap <silent> <dev>Q  :<C-u>CocCommand fzf-preview.CocDiagnostics<CR>
" nnoremap <silent> <dev>rf :<C-u>CocCommand fzf-preview.CocReferences<CR>
" nnoremap <silent> <dev>t  :<C-u>CocCommand fzf-preview.CocTypeDefinitions<CR>

" AutoCmd User fzf_preview#initialized call s:fzf_preview_settings()

" function! s:buffers_delete_from_lines(lines) abort
"   for line in a:lines
"     let matches = matchlist(line, '\[\(\d\+\)\]')
"     if len(matches) >= 1
"       execute 'Bdelete! ' . matches[1]
"     endif
"   endfor
" endfunction

" function! s:fzf_preview_settings() abort
"   let g:fzf_preview_grep_preview_cmd = 'COLORTERM=truecolor ' . g:fzf_preview_grep_preview_cmd
"   let g:fzf_preview_command = 'COLORTERM=truecolor ' . g:fzf_preview_command
"
"   let g:fzf_preview_git_status_preview_command = " test (git diff --cached -- {-1}) != \"\" && git diff --cached --color=always -- {-1} || " .
"   \ "test (git diff -- {-1}) != \"\" && git diff --color=always -- {-1} || " .
"   \ g:fzf_preview_command
"
"   echo 'g:fzf_preview_git_status_preview_command'
"   echo g:fzf_preview_git_status_preview_command
"
"   let g:fzf_preview_custom_processes['open-file'] = fzf_preview#remote#process#get_default_processes('open-file', 'coc')
"   let g:fzf_preview_custom_processes['open-file']['ctrl-s'] = g:fzf_preview_custom_processes['open-file']['ctrl-x']
"   call remove(g:fzf_preview_custom_processes['open-file'], 'ctrl-x')
"
"   let g:fzf_preview_custom_processes['open-buffer'] = fzf_preview#remote#process#get_default_processes('open-buffer', 'coc')
"   let g:fzf_preview_custom_processes['open-buffer']['ctrl-s'] = g:fzf_preview_custom_processes['open-buffer']['ctrl-x']
"   call remove(g:fzf_preview_custom_processes['open-buffer'], 'ctrl-q')
"   let g:fzf_preview_custom_processes['open-buffer']['ctrl-x'] = get(function('s:buffers_delete_from_lines'), 'name')
"
"   let g:fzf_preview_custom_processes['open-bufnr'] = fzf_preview#remote#process#get_default_processes('open-bufnr', 'coc')
"   let g:fzf_preview_custom_processes['open-bufnr']['ctrl-s'] = g:fzf_preview_custom_processes['open-bufnr']['ctrl-x']
"   call remove(g:fzf_preview_custom_processes['open-bufnr'], 'ctrl-q')
"   let g:fzf_preview_custom_processes['open-bufnr']['ctrl-x'] = get(function('s:buffers_delete_from_lines'), 'name')
"
"   let g:fzf_preview_custom_processes['git-status'] = fzf_preview#remote#process#get_default_processes('git-status', 'coc')
"   let g:fzf_preview_custom_processes['git-status']['ctrl-s'] = g:fzf_preview_custom_processes['git-status']['ctrl-x']
"   call remove(g:fzf_preview_custom_processes['git-status'], 'ctrl-x')
"
" endfunction

" }}}

" quickrun {{{
nnoremap \r :write<CR>:QuickRun<CR>

let g:quickrun_config = {'_': {}}

if has('nvim')
  let g:quickrun_config._.runner = 'neovim_job'
elseif exists('*ch_close_in')
  let g:quickrun_config._.runner = 'job'
endif

let g:quickrun_config['rspec'] = {
  \   'command': 'rspec',
  \   'exec': 'bundle exec %c --no-color %s',
  \   'filetype': 'rspec-result'
  \ }
let g:quickrun_config['rspec.line'] = {
  \   'command': 'rspec',
  \   'exec': 'bundle exec %c %s:%a',
  \   'filetype': 'rspec-result'
  \ }
function! s:RSpecQuickrun()
  set filetype=ruby.rspec
  let b:quickrun_config = { 'type': 'rspec' }
  nnoremap <silent> \t :write<CR>:execute 'QuickRun rspec.line -args ' . line('.')<CR>
endfunction
autocmd BufWinEnter,BufNewFile *_spec.rb call <SID>RSpecQuickrun()
" }}}

" UltiSnips {{{
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsJumpForwardTrigger="<Tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"
 
let g:UltiSnipsEditSplit="vertical"

" dash.vim {{{
nmap <silent> <leader>d <Plug>DashSearch
" }}}

" vim-expand-region {{{
call expand_region#custom_text_objects('ruby', {
  \ 'im' :0,
  \ 'am' :0,
  \ })
" }}}

" gitgutter {{{

" default ]c [c
nmap gn <Plug>(GitGutterNextHunk)
nmap gp <Plug>(GitGutterPrevHunk)
nmap <silent>,gr :<C-u>GitGutterUndoHunk<CR>
" }}}

" tagbar {{{
nmap <silent> <F4> :TagbarToggle<CR>
let g:tagbar_autofocus = 1

let g:tagbar_type_ruby = {
  \ 'kinds' : [
    \ 'm:modules',
    \ 'c:classes',
    \ 'd:describes',
    \ 'C:contexts',
    \ 'f:methods',
    \ 'F:singleton methods'
  \ ]
\ }
" }}}

" lightline {{{
let g:lightline = {
  \ 'colorscheme': 'seoul256',
  \ 'separator': { 'left': "\u2b80", 'right': "\u2b82" },
  \ 'subseparator': { 'left': "\u2b81", 'right': "\u2b83" },
  \'active': {
  \  'left': [
  \    ['mode', 'paste'],
  \    ['readonly', 'filename', 'modified', 'ale'],
  \  ]
  \},
  \'component_function': {
  \  'filename': 'LightlineFilename',
  \  'ale': 'ALEGetStatusLine'
  \}
\ }

function! LightlineFilename()
  let filename = expand('%:t') !=# '' ? expand('%:h') . '/' . expand('%:t') : '[No Name]'
  let modified = &modified ? ' +' : ''
  return filename . modified
endfunction

function! LightlineMode()
  return  &ft == 'denite' ? 'Denite' :
    \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction
" }}}

" ale {{{
autocmd BufRead,BufNewFile *.slim setfiletype slim
let g:ale_linters = {
  \   'ruby': ['rubocop', 'reek', 'ruby', 'brakeman', 'rails_best_practices'],
  \   'slim': ['slimlint'],
  \   'markdown': ['textlint', 'markdownlint'],
  \   'text': ['textlint'],
  \}
let g:ale_completion_enabled = 1
let g:ale_ruby_rubocop_options = '-c ./.rubocop.yml'
let g:ale_sign_column_always = 1
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'
" }}}

" tagbar {{{
nmap <silent><F4> :<C-u>TagbarToggle<CR>
let g:tagbar_autofocus = 1
" }}}

" jscomplete-vim {{{
autocmd FileType javascript setlocal omnifunc=jscomplete#CompleteJS
" }}}

" myhere/vim-nodejs-complete {{{
autocmd FileType javascript setlocal omnifunc=nodejscomplete#CompleteJS
if !exists('g:neocomplcache_omni_functions')
  let g:neocomplcache_omni_functions = {}
endif
let g:neocomplcache_omni_functions.javascript = 'nodejscomplete#CompleteJS'

let g:node_usejscomplete = 1
" }}}

" git-messenger {{{
let g:git_messenger_no_default_mappings = v:true
nmap ,gm <Plug>(git-messenger)
"}}}

set encoding=UTF-8
" default setting
nnoremap ; :
" nnoremap : ;
set sh=bash

set autoindent
set smartindent
set showmatch
set matchpairs+=<:>
set matchtime=1
set number relativenumber
set confirm
"set smarttab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set list
set listchars=tab:->,trail:_
set ruler
set splitright
set backspace=indent,eol,start
" set ambiwidth=double " Unicodeで曖昧な文字2バイト表示
set textwidth=0      " 一行に長い文章を書いていても自動折り返しをしない
set display=lastline
set pumheight=10  "補完メニューの幅
set backupskip=/tmp/*,/private/tmp/*
set noswapfile
set expandtab
set tags+=.git/tags
set mouse=

" search {{{
set incsearch
set ignorecase
set smartcase
set hlsearch
nnoremap <silent><Esc><Esc> :nohlsearch<CR>
set modeline
set modelines=10
set inccommand=split
" }}}

" {{{
" Ctrl + hjkl でウィンドウ間を移動
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" }}}

cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-d> <Del>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>
cnoremap <C-y> <C-r>*
cnoremap <C-g> <C-c>
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>

" 入力モードでのカーソル移動
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

" terminal mode
tnoremap <silent> <ESC> <C-\><C-n>
tnoremap <silent> <C-s> <Nop>


set sidescroll=1
set ttimeoutlen=10
if has('persistent_undo')
  if !isdirectory($HOME.'/.vim/.undodir')
    call mkdir($HOME.'/.vim/.undodir', 'p', 0700)
  endif
  set undodir=~/.vim/.undodir
  set undofile
endif

" vimrc control {{{
nnoremap <silent><Space>. :<C-u>tabnew $MYVIMRC<CR>
nnoremap <silent><Space>s. :<C-u>source $MYVIMRC<CR>
" }}}

" bell {{{
" stop bell
set visualbell t_vb=
" }}}

nnoremap Y y$
nnoremap x "_x
nnoremap xp "0x"0p
nnoremap cw "_cw
nnoremap ce "_ce

" ビジュアルモード時vで行末まで選択
vnoremap v $h
" ビジュアルモードyank後最後の行に移動
vnoremap y y`>

" ddでレジスタを更新しても対応
noremap PP "0p

if has('mac')
  set clipboard+=unnamedplus
endif

" Tab
nnoremap t <Nop>
nnoremap <silent> tt :<C-u>tabnew<CR>:tabmove<CR>
" nnoremap <silent> td :<C-u>tabnew %:h<CR>
nnoremap <silent> tw :<C-u>tabclose<CR>
nnoremap <silent> tn :<C-u>tabnext<CR>
nnoremap <silent> tp :<C-u>tabprevious<CR>
" tag のリンクを tabで開く
" nnoremap <silent> <C-t><C-]> <C-w><C-]><C-w>T
nnoremap <silent> tj :<C-u>tab stjump <C-R>=expand('<cword>')<CR><CR>zz

" 日付追加
inoremap <expr> ,df strftime('%Y-%m-%d %H:%M')
inoremap <expr> ,dd strftime('%Y-%m-%d')
inoremap <expr> ,dt strftime('%H:%M')

" filetype of ruby 
autocmd BufNewFile,BufRead *.jbuilder set filetype=ruby
autocmd BufNewFile,BufRead .pryrc     set filetype=ruby
autocmd FileType ruby setl iskeyword+=?

" sudo権限で保存
cnoremap w!! w !sudo tee > /dev/null %<CR>

augroup fileTypeIndent
  autocmd!
  autocmd BufNewFile, BufRead *.tsv setlocal noexpandtab
augroup END

autocmd ColorScheme * highlight NormalFloat ctermbg=17 guibg=#374549
set termguicolors
colorscheme tender
