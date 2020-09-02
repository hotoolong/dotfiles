if &compatible
  set nocompatible
endif

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'tpope/vim-sensible'
Plug 'junegunn/seoul256.vim'

" file finder
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': [] }
Plug 'rhysd/git-messenger.vim'
Plug 'rhysd/conflict-marker.vim'

" file finder
Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/neomru.vim'

" ほかん
Plug 'cohama/lexima.vim'
Plug 'zxqfl/tabnine-vim', { 'on': [] }

" snippet
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'prabirshrestha/asyncomplete-ultisnips.vim'

" ruby rails
Plug 'vim-ruby/vim-ruby', { 'on': [] }
Plug 'tpope/vim-rails', { 'on': [] }
Plug 'slim-template/vim-slim', { 'on': [] }
Plug 'tomtom/tcomment_vim', { 'on': [] }

" vimdoc
Plug 'vim-jp/vimdoc-ja'

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

" LSP
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp', { 'on': [] }
Plug 'mattn/vim-lsp-settings', { 'on': [] }

" Fuzzy Finder
Plug 'mattn/vim-fz'

" ctags
Plug 'majutsushi/tagbar'
Plug 'pechorin/any-jump.vim'

" シンタックスチェック
Plug 'w0rp/ale'
Plug 'delphinus/lightline-delphinus'
Plug 'itchyny/lightline.vim'

" Nextword
Plug 'high-moctane/asyncomplete-nextword.vim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'gregsexton/gitv'
Plug 'airblade/vim-gitgutter'
Plug 'iberianpig/tig-explorer.vim'
Plug 'rbgrouleff/bclose.vim'

" fzf preview
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'yuki-ycino/fzf-preview.vim'

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
Plug 'sheerun/vim-polyglot'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" Load Event
function! s:load_plug(timer)
    call plug#load(
                \ 'vim-ruby',
                \ 'vim-rails',
                \ 'vim-slim',
                \ 'tcomment_vim',
                \ 'nerdtree-git-plugin',
                \ 'vim-lsp',
                \ 'vim-lsp-settings',
                \ 'tabnine-vim',
                \ )
endfunction

" Heavy plug-ins will be loaded later.
call timer_start(500, function("s:load_plug"))

filetype plugin indent on
syntax enable

let mapleader = "\<Space>"

" UltiSnips {{{
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsJumpForwardTrigger="<c-l>"
let g:UltiSnipsJumpBackwardTrigger="<c-h>"
 
let g:UltiSnipsEditSplit="vertical"
call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
    \ 'name': 'ultisnips',
    \ 'whitelist': ['*'],
    \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
    \ }))
" }}}

" dash.vim {{{
nmap <silent> <leader>d <Plug>DashSearch
" }}}

" vim-expand-region {{{
call expand_region#custom_text_objects('ruby', {
  \ 'im' :0,
  \ 'am' :0,
  \ })
" }}}

" vim-lsp {{{
let g:lsp_diagnostics_enabled = 0
let g:lsp_diagnostics_echo_cursor = 0
let g:lsp_text_edit_enabled = 0

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> <f2> <plug>(lsp-rename)
  " refer to doc to add more commands
endfunction

augroup lsp_install
  au!
  " call s:on_lsp_buffer_enabled only for languages that has the server registered.
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
" }}}

" asyncomplete {{{
set completeopt=menuone,noselect,preview
inoremap <expr><CR>  pumvisible() ? "<C-y>" : "<CR>"<buffer>
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 0
let g:asyncomplete_popup_delay = 20
"  }}}

" high-moctane/asyncomplete-nextword.vim {{{
call asyncomplete#register_source(asyncomplete#sources#nextword#get_source_options({
  \   'name': 'nextword',
  \   'whitelist': ['*'],
  \   'args': ['-n', '10000'],
  \   'completor': function('asyncomplete#sources#nextword#completor')
  \   }))
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
  \  'ale': 'ALEGetStatusLine'
  \}
\ }

function! LightlineMode()
  return  &ft == 'denite' ? 'Denite' :
    \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction
" }}}

" ale {{{
autocmd BufRead,BufNewFile *.slim setfiletype slim
let g:ale_linters = {
  \   'ruby': ['rubocop', 'reek', 'ruby', 'brakeman'],
  \   'slim': ['slimlint'],
  \   'markdown': ['textlint', 'markdownlint'],
  \   'text': ['textlint'],
  \}
let g:ale_completion_enabled = 1
let g:ale_ruby_rubocop_options = '--rails -c ./.rubocop.yml'
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
nmap ,m <Plug>(git-messenger)
"}}}

" NERDTree {{{
let NERDTreeChDirMode=2
let NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']
let NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
let NERDTreeShowBookmarks=1
let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeMapOpenInTab='<C-t>'
let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
let g:NERDTreeWinSize = 35
let NERDTreeAutoDeleteBuffer = 1
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite
nnoremap <silent> td :<C-u>NERDTreeFind<CR>
" nnoremap <silent> <F3> :<C-u>NERDTreeToggle<CR>
" 隠しファイルを表示する
let NERDTreeShowHidden = 1
"nnoremap <silent><C-e> :NERDTreeFocusToggle<CR>

" 他のバッファをすべて閉じた時にNERDTreeが開いていたらNERDTreeも一緒に閉じる。
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" }}}

" jistr/vim-nerdtree-tabs {{{
" デフォルトでツリーを表示させる
let g:nerdtree_tabs_open_on_console_startup=1
let g:nerdtree_tabs_autofind=1
" }}}

" Xuyuanp/nerdtree-git-plugin {{{
let g:NERDTreeGitStatusIndicatorMapCustom = {
  \ "Modified"  : "✹",
  \ "Staged"    : "✚",
  \ "Untracked" : "✭",
  \ "Renamed"   : "➜",
  \ "Unmerged"  : "═",
  \ "Deleted"   : "✖",
  \ "Dirty"     : "✗",
  \ "Clean"     : "✔︎",
  \ 'Ignored'   : '☒',
  \ "Unknown"   : "?"
  \ }
" }}}

" denite.vim {{{
" 入力モードで開始する
let g:unite_enable_start_insert = 1
" 履歴の取得
let g:unite_source_history_yank_enable =1

" The prefix key.
nnoremap  [denite] <Nop>
nmap , [denite]

nnoremap [denite]  :<C-u>Denite -no-split<Space>
nnoremap <silent> [denite]b :<C-u>Denite -split=floating buffer<CR>
nnoremap <silent> [denite]m :<C-u>Denite<Space>file_mru<CR>
nnoremap <silent> [denite]r :<C-u>Denite<Space>file_rec<CR>
nnoremap <silent> [denite]f :<C-u>DeniteWithBufferDir file<CR>
nnoremap <silent> [denite]rg :<C-u>Denite -resume -buffer-name=search-buffer-denite<CR>
nnoremap <silent> [denite]g :<C-u>Denite grep -buffer-name=search-buffer-denite<CR>
" resumeした検索結果の次の行の結果へ飛ぶ
nnoremap <silent> [denite]n :<C-u>Denite -resume -buffer-name=search-buffer-denite -select=+1 -immediately<CR>
" resumeした検索結果の前の行の結果へ飛ぶ
nnoremap <silent> [denite]p :<C-u>Denite -resume -buffer-name=search-buffer-denite -select=-1 -immediately<CR>
" denite/insert モードのときは，C- で移動できるようにする
call denite#custom#map('insert', "<C-j>", '<denite:move_to_next_line>')
call denite#custom#map('insert', "<C-k>", '<denite:move_to_previous_line>')
" tabopen や vsplit のキーバインドを割り当て
call denite#custom#map('insert', "<C-t>", '<denite:do_action:tabopen>')
call denite#custom#map('insert', "<C-v>", '<denite:do_action:vsplit>')
call denite#custom#map('normal', "v", '<denite:do_action:vsplit>')
"カレントディレクトリ内の検索もrgを使用する
call denite#custom#var('file_rec', 'command',
      \ ['rg', '--follow', '--nocolor', '--nogroup', '-g', ''])
" Ripgrep command on grep source
call denite#custom#var('grep', 'command', ['rg'])
call denite#custom#var('grep', 'default_opts',
    \ ['--vimgrep', '--no-heading'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])
" use flating
let s:denite_win_width_percent = 0.85
let s:denite_win_height_percent = 0.7

call denite#custom#option('default', {
  \ 'split': 'floating',
  \ 'winwidth': float2nr(&columns * s:denite_win_width_percent),
  \ 'wincol': float2nr((&columns - (&columns * s:denite_win_width_percent)) / 2),
  \ 'winheight': float2nr(&lines * s:denite_win_height_percent),
  \ 'winrow': float2nr((&lines - (&lines * s:denite_win_height_percent)) / 2),
  \ })

autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
  \ denite#do_map('toggle_select').'j'
endfunction

" }}}

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
"set smarttab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set list
set listchars=tab:->,trail:_
set ruler
set splitright
set backspace=indent,eol,start
set ambiwidth=double " Unicodeで曖昧な文字2バイト表示
set textwidth=0      " 一行に長い文章を書いていても自動折り返しをしない
set display=lastline
set pumheight=10  "補完メニューの幅
set backupskip=/tmp/*,/private/tmp/*
set noswapfile
set expandtab

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

" 入力モードでのカーソル移動
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

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
" ビープを止める
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
nnoremap <silent> t<C-]> :<C-u>tab stj <C-R>=expand('<cword>')<CR><CR>

" 日付追加
inoremap <expr> ,df strftime('%Y-%m-%d %H:%M')
inoremap <expr> ,dd strftime('%Y-%m-%d')
inoremap <expr> ,dt strftime('%H:%M')

" sudo権限で保存
cnoremap w!! w !sudo tee > /dev/null %<CR>

augroup fileTypeIndent
  autocmd!
  autocmd BufNewFile, BufRead *.tsv setlocal noexpandtab
augroup END

autocmd ColorScheme * highlight NormalFloat ctermbg=17 guibg=#374549
set termguicolors
colorscheme tender
