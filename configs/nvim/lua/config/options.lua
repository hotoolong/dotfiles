vim.opt.number = true
vim.opt.updatetime = 500
vim.opt.cursorline = true
vim.cmd.highlight({ "clear", "CursorLine" })
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

vim.opt.clipboard:append('unnamedplus')
vim.opt.encoding = "UTF-8"

vim.opt.sh = 'bash'
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.showmatch = true
vim.opt.matchpairs:append('<:>')
vim.opt.matchtime = 1
vim.opt.confirm = true
vim.opt.softtabstop = 2
vim.opt.list = true
vim.opt.listchars = "tab:->,trail:_"
vim.opt.ruler = true
vim.opt.splitright = true
vim.opt.backspace = "indent,eol,start"
vim.opt.textwidth = 0 -- 一行に長い文章を書いていても自動折り返しをしない
vim.opt.display = 'lastline'
vim.opt.pumheight = 10
vim.opt.backupskip = "/tmp/*,/private/tmp/*"
vim.opt.swapfile = false
vim.opt.tags:append('.git/tags')
vim.opt.mouse = ""

-- search
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.modeline = true
vim.opt.modelines = 10
vim.opt.inccommand = 'split'

vim.opt.sidescroll = 1
vim.opt.ttimeoutlen = 10

if vim.fn.has('persistent_undo') == 1 then
  if not vim.fn.isdirectory(vim.env.HOME .. '/.vim/undodir') then
    vim.fn.mkdir(vim.env.HOME .. '/.vim/undodir', 'p', 0700)
  end
  vim.opt.undodir = vim.env.HOME .. '/.vim/undodir'
  vim.opt.undofile = true
end

vim.opt.termguicolors = true
