-- map prefix
vim.keymap.set({ 'n', 'x' }, '<Space>', '<Nop>')
vim.keymap.set({ 'n', 'x' }, '<Plug>(lsp)', '<Nop>')
vim.keymap.set({ 'n', 'x' }, 'm', '<Plug>(lsp)')
vim.keymap.set({ 'n', 'x' }, '<Plug>(ff)', '<Nop>')
vim.keymap.set({ 'n', 'x' }, ',', '<Plug>(ff)')

vim.keymap.set({ 'n' }, ';', ':')
vim.keymap.set({ 'n' }, '<Esc><Esc>', '<Cmd>nohlsearch<CR>', { silent = true })

-- Ctrl + hjkl でウィンドウ間を移動
vim.keymap.set({ 'n' }, '<C-h>', '<C-w>h')
vim.keymap.set({ 'n' }, '<C-j>', '<C-w>j')
vim.keymap.set({ 'n' }, '<C-k>', '<C-w>k')
vim.keymap.set({ 'n' }, '<C-l>', '<C-w>l')

-- command keymap
vim.keymap.set({ 'c' }, '<C-a>', '<Home>')
vim.keymap.set({ 'c' }, '<C-b>', '<Left>')
vim.keymap.set({ 'c' }, '<C-d>', '<Del>')
vim.keymap.set({ 'c' }, '<C-e>', '<End>')
vim.keymap.set({ 'c' }, '<C-f>', '<Right>')
vim.keymap.set({ 'c' }, '<C-n>', '<Down>')
vim.keymap.set({ 'c' }, '<C-p>', '<Up>')
vim.keymap.set({ 'c' }, '<C-y>', '<C-r>*')
vim.keymap.set({ 'c' }, '<C-g>', '<C-c>')
vim.keymap.set({ 'c' }, '<M-b>', '<S-Left>')
vim.keymap.set({ 'c' }, '<M-f>', '<S-Right>')

-- input mode keymap
vim.keymap.set({ 'i' }, '<C-j>', '<Down>')
vim.keymap.set({ 'i' }, '<C-k>', '<Up>')
vim.keymap.set({ 'i' }, '<C-h>', '<Left>')
vim.keymap.set({ 'i' }, '<C-l>', '<Right>')

-- terminal mode keymap
vim.keymap.set({ 't' }, '<ESC>', '<C-\\><C-n>')
vim.keymap.set({ 't' }, '<C-s>', '<Nop>')

vim.keymap.set({ 'n' }, 'Y', 'y$')
vim.keymap.set({ 'n' }, 'x', '"_x')
vim.keymap.set({ 'n' }, 'xp', '"0x"0p')
vim.keymap.set({ 'n' }, 'cw', '"_cw')
vim.keymap.set({ 'n' }, 'ce', '"_ce')

-- ビジュアルモード時vで行末まで選択
vim.keymap.set({ 'v' }, 'v', '$h')
-- ビジュアルモードyank後最後の行に移動
vim.keymap.set({ 'v' }, 'y', 'y`>')
-- ddでレジスタを更新しても対応
vim.keymap.set({ 'n' }, 'PP', '"0p')

-- Tab
vim.keymap.set({ 'n' }, 't', '<Nop>')
vim.keymap.set({ 'n' }, 'tt', ':<C-u>tabnew<CR>:tabmove<CR>', { silent = true })
vim.keymap.set({ 'n' }, 'tw', ':<C-u>tabclose<CR>', { silent = true })
vim.keymap.set({ 'n' }, 'tn', ':<C-u>tabnext<CR>', { silent = true })
vim.keymap.set({ 'n' }, 'tp', ':<C-u>tabprevious<CR>', { silent = true })
-- tag のリンクを tabで開く
vim.keymap.set({ 'n' }, 'tj', ":<C-u>tab stjump <C-R>=expand('<cword>')<CR><CR>zz", { silent = true })

-- 日付追加
vim.keymap.set({ 'i' }, ',df', "strftime('%Y-%m-%d %H:%M')", { expr = true })
vim.keymap.set({ 'i' }, ',dd', "strftime('%Y-%m-%d')", { expr = true })
vim.keymap.set({ 'i' }, ',dt', "strftime('%H:%M')", { expr = true })
