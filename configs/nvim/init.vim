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
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'rhysd/git-messenger.vim'

" file finder
Plug 'Shougo/denite.nvim'
Plug 'Shougo/neomru.vim'

" ほかん
Plug 'Shougo/deoplete.nvim'
Plug 'cohama/lexima.vim'
Plug 'zxqfl/tabnine-vim'

" ruby rails
Plug 'tpope/vim-rails'
Plug 'slim-template/vim-slim'
Plug 'tomtom/tcomment_vim'

" vimdoc
Plug 'vim-jp/vimdoc-ja'

" markdown
Plug 'mattn/vim-maketable'

" html
Plug 'mattn/emmet-vim'

" vue
Plug 'posva/vim-vue'
  " call dein#add('Shougo/context_filetype.vim')
  " call dein#add('mhartington/nvim-typescript', {
    " \ 'hook_add': 'let g:nvim_typescript#vue_support = 1'
    " \ })

" node
Plug 'moll/vim-node'
Plug 'mattn/jscomplete-vim'
Plug 'myhere/vim-nodejs-complete'
Plug 'pangloss/vim-javascript'

" LSP
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

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

" fzf preview
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'yuki-ycino/fzf-preview.vim'

" colorscheme
Plug 'jacoborus/tender.vim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

filetype plugin indent on
syntax enable

" vim-lsp {{{
let g:lsp_diagnostics_enabled = 0
let g:lsp_log_verbose = 0
let g:lsp_log_file = expand('~/vim-lsp.log')

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

if executable('pyls')
  " pip install python-language-server
  au User lsp_setup call lsp#register_server({
    \ 'name': 'pyls',
    \ 'cmd': {server_info->['pyls']},
    \ 'whitelist': ['python'],
    \ })
endi

if executable('solargraph')
  " gem install solargraph
  au User lsp_setup call lsp#register_server({
    \ 'name': 'solargraph',
    \ 'cmd': {server_info->[&shell, &shellcmdflag, 'solargraph stdio']},
    \ 'initialization_options': {"diagnostics": "true"},
    \ 'whitelist': ['ruby'],
    \ })
endif

if executable('gopls')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'gopls',
    \ 'cmd': {server_info->['gopls', '-mode', 'stdio']},
    \ 'whitelist': ['go'],
    \ })
endi

if executable('typescript-language-server')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'javascript support using typescript-language-server',
    \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
    \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'package.json'))},
    \ 'whitelist': ['javascript', 'javascript.jsx'],
    \ })
endif

" }}

" for asyncomplete.vim log {{{
let g:asyncomplete_log_file = expand('~/asyncomplete.log')
" }}

" asyncomplete {{{
set completeopt+=preview
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
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
  \   'markdown': ['textlint'],
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

" deoplete {{{
let g:deoplete#enable_at_startup = 1
" }}}

" LanguageClient {{{
set hidden
let g:LanguageClient_serverCommands = {
  \ 'ruby': ['solargraph', 'stdio'],
  \ 'javascript': ['vls'],
  \ 'vue': ['vls'],
\}
call deoplete#custom#var('omni', 'input_patterns', {
  \ 'ruby': ['[^. *\t]\.\w*', '[a-zA-Z_]\w*::'],
\})
" }}}

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
let g:NERDTreeIndicatorMapCustom = {
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

" tcomment {{{
if !exists('g:tcomment_types')
  let g:tcomment_types = {}
endif
let g:tcomment_types = {
  \   'fish': '#'
  \  }
" }}}

syntax on
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

"ビジュアルモード時vで行末まで選択
vnoremap v $h

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

autocmd BufNewFile,BufRead *.fish setfiletype fish

autocmd ColorScheme * highlight NormalFloat ctermbg=17 guibg=#374549
set termguicolors
colorscheme tender