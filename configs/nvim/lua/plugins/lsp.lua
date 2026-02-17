return {
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    config = true,
  },
  {
    'williamboman/mason-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'neovim/nvim-lspconfig',
    },
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = {
          'herb_ls',
          'ts_ls',
          'tailwindcss',
          'solargraph',
          'ruby_lsp',
          'yamlls',
          'lua_ls',
        },
        automatic_installation = true,
        automatic_enable = false,
      })

      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            diagnostics = { globals = { 'vim' } }
          }
        }
      })

      vim.lsp.enable({
        'ts_ls',
        'tailwindcss',
        'solargraph',
        'ruby_lsp',
        'yamlls',
        'lua_ls',
      })

      -- steep は Mason からアンインストールするか、
      -- Steepfile のあるプロジェクトで手動で :lua vim.lsp.enable('steep') する
    end
  },
  {
    'nvimdev/lspsaga.nvim',
    event = "LspAttach",
    config = true,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'nvim-treesitter/nvim-treesitter'
    },
    init = function()
      vim.api.nvim_create_autocmd('CursorHold', {
        pattern = "*",
        callback = function()
          if pcall(require, 'lspsaga') then
            vim.cmd([[Lspsaga show_cursor_diagnostics ++unfocus]])
          end
        end,
      })

      local function show_documentation()
        local ft = vim.opt.filetype._value
        if ft == 'vim' or ft == 'help' then
          vim.cmd([[execute 'h ' . expand('<cword>') ]])
        else
          vim.cmd('Lspsaga hover_doc')
        end
      end

      vim.keymap.set({ 'n' }, 'K', show_documentation)
      vim.keymap.set({ 'n' }, '<Plug>(lsp)a', '<Cmd>Lspsaga code_action<CR>')
      vim.keymap.set({ 'n' }, '<Plug>(lsp)rn', '<Cmd>Lspsaga lsp_rename ++project<CR>')
      vim.keymap.set({ 'n' }, '<Plug>(lsp)n', '<cmd>Lspsaga diagnostic_jump_next<CR>')
      vim.keymap.set({ 'n' }, '<Plug>(lsp)p', '<cmd>Lspsaga diagnostic_jump_prev<CR>')
      vim.keymap.set({ 'n' }, '<Plug>(lsp)f', vim.lsp.buf.format)
    end
  },
  {
    'ray-x/lsp_signature.nvim',
    opts = {
      hint_enable = false
    }
  },
  {
    'j-hui/fidget.nvim',
    tag = 'legacy',
    config = true,
  },
}
