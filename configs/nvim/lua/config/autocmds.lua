vim.api.nvim_create_augroup('extra-whitespace', {})
vim.api.nvim_create_autocmd({'VimEnter', 'WinEnter'}, {
    group = 'extra-whitespace',
    pattern = '*',
    command = [[call matchadd('ExtraWhitespace', '[\u00A0\u2000-\u200B\u3000]')]]
})
vim.api.nvim_create_autocmd({'ColorScheme'}, {
  group = 'extra-whitespace',
  pattern = '*',
  callback = function()
    vim.cmd.highlight({ "default", "ExtraWhitespace", "ctermbg=70 guibg=#008800" })
  end,
})

-- filetype of ruby
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.jbuilder", ".pryrc" },
  callback = function()
    vim.bo.filetype = "ruby"
  end
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "ruby",
  callback = function()
    vim.opt.iskeyword:append("?")
  end
})

local fileTypeIndent = vim.api.nvim_create_augroup("fileTypeIndent", { clear = true })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.tsv",
  command = "setlocal noexpandtab",
  group = fileTypeIndent
})
