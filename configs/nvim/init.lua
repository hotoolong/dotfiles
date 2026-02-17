if vim.o.compatible then
  vim.o.compatible = false
end

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ' '

require('config.options')
require('config.keymaps')
require('config.autocmds')

require('lazy').setup('plugins')

require('coverage')

-- 環境固有の設定 (gitignore対象、ファイルがなくてもエラーにならない)
pcall(require, 'config.local')

vim.cmd.colorscheme('kanagawa-dragon')
