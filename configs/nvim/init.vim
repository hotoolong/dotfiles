if &compatible
  set nocompatible
endif
" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'tpope/vim-sensible'
Plug 'junegunn/seoul256.vim'

" file finder
Plug 'preservim/nerdtree' |
            \ Plug 'Xuyuanp/nerdtree-git-plugin' |
            \ Plug 'ryanoasis/vim-devicons'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'rhysd/git-messenger.vim'
Plug 'rhysd/conflict-marker.vim'

" file finder
Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/neomru.vim'

" snippet
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'prabirshrestha/asyncomplete-ultisnips.vim'

" ruby rails
Plug 'vim-ruby/vim-ruby', { 'on': [] }
Plug 'tpope/vim-rails', { 'on': [] }
Plug 'slim-template/vim-slim', { 'on': [] }
Plug 'tomtom/tcomment_vim', { 'on': [] }

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
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

" Fuzzy Finder
Plug 'mattn/vim-fz'

" ctags
Plug 'majutsushi/tagbar'
Plug 'pechorin/any-jump.vim'

" シンタックスチェック
Plug 'dense-analysis/ale'
Plug 'delphinus/lightline-delphinus'
Plug 'itchyny/lightline.vim'

" asyncomplete sources
Plug 'high-moctane/asyncomplete-nextword.vim'
Plug 'hotoolong/asyncomplete-tabnine.vim', { 'do': './install.sh' }
if executable('ctags')
  Plug 'prabirshrestha/asyncomplete-tags.vim'
endif

filetype plugin indent on
syntax enable

let mapleader = "\<Space>"

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
Plug 'lambdalisue/vim-quickrun-neovim-job'
Plug 'sheerun/vim-polyglot'
Plug 'hotoolong/translate.nvim'
Plug 'AndrewRadev/switch.vim'
Plug 'lambdalisue/pastefix.vim'

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

" hotoolong/translate.nvim {{{
let g:translate_copy_result = 1
" }}}

" tpope/vim-fugitive {{{
autocmd BufWritePost *
      \ if exists('b:git_dir') && executable(b:git_dir.'/hooks/create_tags') |
      \   call system('"'.b:git_dir.'/hooks/create_ctags" &') |
      \ endif
" }}}

" prabirshrestha/asyncomplete-tags.vim {{{
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#tags#get_source_options({
    \ 'name': 'tags',
    \ 'whitelist': ['c'],
    \ 'completor': function('asyncomplete#sources#tags#completor'),
    \ 'config': {
    \    'max_file_size': 50000000,
    \  },
    \ }))
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

" quickrun {{{
nnoremap \r :write<CR>:QuickRun<CR>

let g:quickrun_config = {'_': {}}

if has('nvim')
  let g:quickrun_config._.runner = 'neovim_job'
elseif exists('*ch_close_in')
  let g:quickrun_config._.runner = 'job'
endif

let g:quickrun_config['ruby.rspec'] = {
  \   'command': 'rspec',
  \   'cmdopt': '-f p',
  \   'exec': 'bundle exec %c %o %s',
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

" hotoolong/asyncomplete-tabnine {{{
call asyncomplete#register_source(asyncomplete#sources#tabnine#get_source_options({
  \ 'name': 'tabnine',
  \ 'allowlist': ['*'],
  \ 'completor': function('asyncomplete#sources#tabnine#completor'),
  \ 'config': {
  \   'line_limit': 1000,
  \   'max_num_result': 20,
  \  },
  \ })) 
" }}}

" UltiSnips {{{
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsJumpForwardTrigger="<Tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"
 
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
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
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
set completeopt=menuone,noselect,preview,noinsert
inoremap <expr><Tab>  pumvisible() ? "\<C-y>" : "\<Tab>"
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 0
let g:asyncomplete_popup_delay = 20

autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#ale#get_source_options({
\ 'priority': 10
\ }))

"  }}}

" high-moctane/asyncomplete-nextword.vim {{{
call asyncomplete#register_source(asyncomplete#sources#nextword#get_source_options({
  \   'name': 'nextword',
  \   'whitelist': ['*'],
  \   'args': ['-n', '20'],
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
nmap ,gm <Plug>(git-messenger)
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
" show hidden file
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

" denite.vim {{{

augroup denite_filter
  autocmd FileType denite call s:denite_my_settings()
  function! s:denite_my_settings() abort
    nnoremap <silent><buffer><expr> <CR>    denite#do_map('do_action')
    nnoremap <silent><buffer><expr> d       denite#do_map('do_action', 'delete')
    nnoremap <silent><buffer><expr> p       denite#do_map('do_action', 'preview')
    nnoremap <silent><buffer><expr> q       denite#do_map('quit')
    nnoremap <silent><buffer><expr> i       denite#do_map('open_filter_buffer')
    nnoremap <silent><buffer><expr> <Space> denite#do_map('toggle_select').'j'
  endfunction

  autocmd FileType denite-filter call s:denite_filter_my_settings()
  function! s:denite_filter_my_settings() abort
    inoremap <silent><buffer> <C-j> <Esc>
          \:call denite#move_to_parent()<CR>
          \:call cursor(line('.')+1,0)<CR>
          \:call denite#move_to_filter()<CR>A
    inoremap <silent><buffer> <C-k> <Esc>
          \:call denite#move_to_parent()<CR>
          \:call cursor(line('.')-1,0)<CR>
          \:call denite#move_to_filter()<CR>A
  endfunction

  " denite/insert モードのときは，C- で移動できるようにする
  " call denite#custom#map('insert', "<C-j>", '<denite:move_to_next_line>', 'noremap')
  " call denite#custom#map('insert', "<C-k>", '<denite:move_to_previous_line>', 'noremap')
  call denite#custom#map('insert', '<C-n>', '<denite:move_to_next_line>', 'noremap')
  call denite#custom#map('insert', '<C-p>', '<denite:move_to_previous_line>', 'noremap')
  " tabopen や vsplit のキーバインドを割り当て
  call denite#custom#map('insert', "<C-t>", '<denite:do_action:tabopen>')
  call denite#custom#map('insert', "<C-v>", '<denite:do_action:vsplit>')
  call denite#custom#map('normal', "v", '<denite:do_action:vsplit>')

augroup END

" use flating
let s:denite_win_width_percent = 0.8
let s:denite_win_height_percent = 0.7

let s:denite_default_options = {
    \ 'split': 'floating',
    \ 'winwidth': float2nr(&columns * s:denite_win_width_percent),
    \ 'wincol': float2nr((&columns - (&columns * s:denite_win_width_percent)) / 2),
    \ 'winheight': float2nr(&lines * s:denite_win_height_percent),
    \ 'winrow': float2nr((&lines - (&lines * s:denite_win_height_percent)) / 2),
    \ 'highlight_filter_background': 'DeniteFilter',
    \ 'prompt': '$ ',
    \ 'start_filter': v:true,
    \ }
let s:denite_option_array = []
for [key, value] in items(s:denite_default_options)
  call add(s:denite_option_array, '-'.key.'='.value)
endfor
call denite#custom#option('default', s:denite_default_options)

call denite#custom#var('file/rec', 'command',
    \ ['rg', '--files', '--glob', '!.git', '--color', 'never'])

call denite#custom#filter('matcher/ignore_globs', 'ignore_globs',
    \ [ '.git/', '.ropeproject/', '__pycache__/',
    \   'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])

" Ripgrep command on grep source
call denite#custom#var('grep', {
  \ 'command': ['rg'],
  \ 'default_opts': ['-i', '--vimgrep', '--no-heading'],
  \ 'recursive_opts': [],
  \ 'pattern_opt': ['--regexp'],
  \ 'separator': ['--'],
  \ 'final_opts': [],
  \ })

" grep
command! -nargs=? Dgrep call s:Dgrep(<f-args>)
function s:Dgrep(...)
  if a:0 > 0
    execute(':Denite -buffer-name=grep-buffer-denite grep -path='.a:1)
  else
    execute(':Denite -buffer-name=grep-buffer-denite '.join(s:denite_option_array, ' ').' grep')
  endif
endfunction
" show Denite grep results
command! Dresume execute(':Denite -resume -buffer-name=grep-buffer-denite '.join(s:denite_option_array, ' ').'')
" next Denite grep result
command! Dnext execute(':Denite -resume -buffer-name=grep-buffer-denite -cursor-pos=+1 -immediately '.join(s:denite_option_array, ' ').'')
" previous Denite grep result
command! Dprev execute(':Denite -resume -buffer-name=grep-buffer-denite -cursor-pos=-1 -immediately '.join(s:denite_option_array, ' ').'')

" The prefix key.
nnoremap  [denite] <Nop>
nmap , [denite]

" nnoremap [denite]  :<C-u>Denite -no-split<Space>
nnoremap <silent> [denite]b  :<C-u>Denite -split=floating buffer<CR>
nnoremap <silent> [denite]m  :<C-u>Denite<Space>file_mru<CR>
nnoremap <silent> [denite]r  :<C-u>Denite<Space>file/rec<CR>
nnoremap <silent> [denite]f  :<C-u>Denite<Space>file<CR>
nnoremap <silent> [denite]g  :<C-u>Dgrep<CR>
nnoremap <silent> [denite]rg :<C-u>DResume<CR>
nnoremap <silent> [denite]n  :<C-u>Dnext<CR>
nnoremap <silent> [denite]p  :<C-u>Dprev<CR>
nnoremap <silent> [denite]c  :<C-u>Denite command command_history<CR>
nnoremap <silent> [denite]j  :<C-u>Denite jump<CR>
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
" set ambiwidth=double " Unicodeで曖昧な文字2バイト表示
set textwidth=0      " 一行に長い文章を書いていても自動折り返しをしない
set display=lastline
set pumheight=10  "補完メニューの幅
set backupskip=/tmp/*,/private/tmp/*
set noswapfile
set expandtab
set tags+=.git/tags

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
