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

require('lazy').setup({
  { 'vim-jp/vimdoc-ja', ft = 'help' },
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate', -- :MasonUpdate updates registry contents
    config = function()
      require('mason').setup()
    end,
  },
  {
    'williamboman/mason-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'neovim/nvim-lspconfig',
    }
  },
  {
    'jayp0521/mason-null-ls.nvim',
    dependencies = {
      'jose-elias-alvarez/null-ls.nvim',
      "williamboman/mason.nvim",
    }
  },
  'stevearc/dressing.nvim',
  {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    branch = 'master',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          'typescript',
          'tsx',
        },
        highlight = {
          enable = true,
          disable = {
            'toml',
            'c_sharp',
          },
        },
        indent = {
          enable = true, -- Enable indentation by tresitter
        }
      })
    end
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
  {
    'tami5/lspsaga.nvim',
    event = "LspAttach",
    config = function()
      require("lspsaga").setup({})
    end,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'nvim-treesitter/nvim-treesitter'
    }
  },
  'ryanoasis/vim-devicons',
  'ray-x/lsp_signature.nvim',
  'onsails/lspkind-nvim',
  {
    'j-hui/fidget.nvim',
    tag = 'legacy'
  },
  -- {
  --   "hrsh7th/nvim-cmp",
  --   -- load cmp on InsertEnter
  --   event = "InsertEnter",
  --   -- these dependencies will only be loaded when cmp loads
  --   -- dependencies are always lazy-loaded unless specified otherwise
  --   dependencies = {
  --     "hrsh7th/cmp-nvim-lsp",
  --     'hrsh7th/cmp-nvim-lsp-signature-help',
  --     'hrsh7th/cmp-buffer',
  --     'hrsh7th/cmp-path',
  --     'hrsh7th/vim-vsnip',
  --     'hrsh7th/cmp-vsnip',
  --   },
  --   -- config = function()
  --   --   -- ...
  --   -- end,
  -- },
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-nvim-lsp-signature-help',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/vim-vsnip',
  {
    'hrsh7th/vim-vsnip-integ',
    dependencies = { 'hrsh7th/vim-vsnip' }
  },
  'hrsh7th/cmp-vsnip',
  'folke/trouble.nvim',
  'lambdalisue/glyph-palette.vim',
  {
    'lambdalisue/fern.vim',
    keys = {
      { "td", "<Cmd>Fern . -drawer -reveal=%<CR>" },
    }
  },
  {
    'lambdalisue/fern-renderer-nerdfont.vim',
    dependencies = {
      'lambdalisue/fern.vim',
      'lambdalisue/nerdfont.vim',
      'lambdalisue/fern-git-status.vim'
    },
    config = function ()
      vim.g["fern#renderer#nerdfont#indent_markers"] = 1
    end
  },
  {
    'yuki-yano/fern-preview.vim',
    dependencies = { 'lambdalisue/fern.vim' }
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = 'Telescope',
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  },
  {
    "nvim-telescope/telescope-live-grep-args.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    -- keys = {
    --   { "<Plug>(ff)g", require('telescope').extensions.live_grep_args.live_grep_args() }
    -- },
    config = function()
      local telescope = require("telescope")
      telescope.load_extension("live_grep_args")
      vim.keymap.set('n', '<Plug>(ff)g', require('telescope').extensions.live_grep_args.live_grep_args, {})
    end
  },
  'sainnhe/gruvbox-material',
  'tomtom/tcomment_vim',
  {
    'glepnir/zephyr-nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
  {
    'rgroli/other.nvim',
    dir = '/Users/hotoolong/ghq/github.com/rgroli/other.nvim',
    keys = {
      { "<leader>o", "<Cmd>Other<CR>", { silent = true } },
    }
  },
  {
    'liuchengxu/vista.vim',
    cmd = 'Vista',
    keys = {
      { "<F4>", "<Cmd>Vista!!<CR>", { silent = true } },
    },
    config = function()
      vim.g.vista_stay_on_open = false
      vim.g.vista_close_on_jump = 1
      vim.g.vista_icon_indent = {"╰─▸ ", "├─▸ "}
    end,
    init = function ()
      vim.api.nvim_create_autocmd('VimEnter', {
        pattern = "*",
        command = "Vista focus"
      })
      vim.api.nvim_create_autocmd('QuitPre', {
        pattern = "*",
        command = "Vista!"
      })
    end
  },
  -- ruby rails
  {
    'jlcrochet/vim-ruby',
    ft = { 'ruby', 'eruby' }
  },
  'jlcrochet/vim-rbs',
  'noprompt/vim-yardoc',
  'tpope/vim-rails',
  'slim-template/vim-slim',
  -- status line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function ()
      require('lualine').setup({
        sections = {
          lualine_c = {
            {
              'filename',
              path = 1,
            }
          }
        }
      })
    end
  },
  -- etc
  'dag/vim-fish',
  {
    'hotoolong/translate.nvim',
    config = function()
      vim.g.translate_copy_result = 1
    end
  },
  {
    'simeji/winresizer',
    config = function()
      vim.g.winresizer_start_key = '<C-z>'
    end
  },
  {
    'thinca/vim-quickrun',
    cmd = 'QuickRun',
    keys = {
      { '\\r', '<Cmd>write<CR><Cmd>QuickRun<CR>', { silent = true } },
    },
    config = function ()
      vim.g.quickrun_config = {
        _ = { runner = "neovim_job" },
        rspec = {
          commnad = "rspec",
          exec = 'bundle exec %c --no-color %s',
          filetype = 'rspec-result'
        },
        ['rspec.line'] = {
          command = 'rspec',
          exec = 'bundle exec %c %s:%a',
          filetype = 'rspec-result'
        }
      }
    end,
    init = function()
      vim.api.nvim_create_autocmd( { "BufWinEnter", "BufNewFile" }, {
        pattern = "*_spec.rb",
        callback = function()
          vim.api.nvim_echo({{ "This is a normal message", "NormalMsg" }}, true, {})
          vim.bo.filetype = 'ruby.rspec'
          vim.b.quickrun_config = { type = 'rspec' }
          vim.api.nvim_buf_set_keymap(0, 'n', '\\t', ':write<CR>:execute "QuickRun rspec.line -args " . line(".")<CR>', { nowait = true, silent = true })
        end
      })
    end
  },
  {
    'lambdalisue/vim-quickrun-neovim-job',
    dependencies = { 'thinca/vim-quickrun' },
  },
  --html
  'mattn/emmet-vim',
  'othree/html5.vim',
  --git
  {
    'rhysd/git-messenger.vim',
    keys = {
      { ",gm", "<Plug>(git-messenger)" },
    },
    config = function()
      vim.g.git_messenger_no_default_mappings = true
      vim.g.git_messenger_include_diff = "current"
      vim.g.git_messenger_always_into_popup = true
    end
  },
  {
    'airblade/vim-gitgutter',
    event = 'BufRead',
    keys = {
      -- default ]c [c
      { 'gn', '<Plug>(GitGutterNextHunk)' },
      { 'gp', '<Plug>(GitGutterPrevHunk)' },
      { ',gr', '<Cmd>GitGutterUndoHunk<CR>', { silent = true } },
    }
  },
  {
    'iberianpig/tig-explorer.vim',
    config = function ()
      vim.cmd([[cnoreabbrev Blame TigBlame]])
    end
  },
  {
    'rhysd/conflict-marker.vim',
    init = function()
      -- disable the default highlight group
      vim.g.conflict_marker_highlight_group = ''

      -- Include text after begin and end markers
      vim.g.conflict_marker_begin = '^<<<<<<< .*$'
      vim.g.conflict_marker_end   = '^>>>>>>> .*$'

      vim.cmd.highlight({ "ConflictMarkerBegin", "guibg=#2f7366" })
      vim.cmd.highlight({ "ConflictMarkerOurs", "guibg=#2e5049" })
      vim.cmd.highlight({ "ConflictMarkerTheirs", "guibg=#344f69" })
      vim.cmd.highlight({ "ConflictMarkerEnd", "guibg=#2f628e" })
      vim.cmd.highlight({ "ConflictMarkerCommonAncestorsHunk", "guibg=#754a81" })
    end
  },
  -- js
  'moll/vim-node',
  'pangloss/vim-javascript',

  -- etc
  {
    'AndrewRadev/switch.vim',
    keys = {
      { "<C-c>", "<Cmd>Switch<CR>", { silent = true } },
    },
    init = function()
      -- switch.vim
      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = { "eruby", "ruby" },
        callback = function()
          vim.b.switch_custom_definitions = {
            {
              [ [[[''"]\(\k\+\)[''"] => \([^),]\+\)]] ] = [[\1: \2 ]],
              [ [[\(\k\+\):\s*\([^},]\+\)]] ] = [["\1" => \2]],
            },
            { 'if', 'unless' },
            { 'present?', 'blank?' },
            { '==', '!=' },
          }
        end
      })
    end
  },
  'mattn/vim-maketable',
  'pechorin/any-jump.vim',
  {
    "rafamadriz/friendly-snippets",
    dependencies = { 'hrsh7th/vim-vsnip', 'hrsh7th/cmp-vsnip' },
  },
  {
    'sheerun/vim-polyglot',
    init = function()
      vim.g.polyglot_disabled = { 'rbs' }
    end
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-treesitter/nvim-treesitter-textobjects' },
    config = function()
      require("nvim-surround").setup({})
    end
  },
  -- {'romgrk/barbar.nvim',
  --   dependencies = {
  --     'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
  --     'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
  --   },
  --   init = function()
  --     vim.g.barbar_auto_setup = false
  --     require("barbar").setup({
  --       auto_hide = true,
  --       highlight_inactive_file_icons = false,
  --       highlight_visible = false
  --     })
  --   end,
  --   version = '^1.0.0', -- optional: only update when a new 1.x version is released
  -- },
})

-- set options
vim.opt.number = true
vim.opt.updatetime = 500
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- map prefix
vim.keymap.set({ 'n', 'x' }, '<Space>', '<Nop>')
vim.keymap.set({ 'n', 'x' }, '<Plug>(lsp)', '<Nop>')
vim.keymap.set({ 'n', 'x' }, 'm', '<Plug>(lsp)')
vim.keymap.set({ 'n', 'x' }, '<Plug>(ff)', '<Nop>')
vim.keymap.set({ 'n', 'x' }, ';', '<Plug>(ff)')

-- telescope.nvim
local actions = require "telescope.actions"
local lga_actions = require("telescope-live-grep-args.actions")
require('telescope').setup({
  defaults = {
    mappings = {
      n = {
        ['<Esc>'] = require('telescope.actions').close,
        ['<C-g>'] = require('telescope.actions').close,
      },
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      }
    }
  },
  extensions = {
    live_grep_args = {
      auto_quoting = true,
      mappings = {
        i = {
          ["<C-w>"] = lga_actions.quote_prompt(),
          ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
        },
      }
    }
  }
})
vim.keymap.set({ 'n' }, '<Plug>(ff)r', '<Cmd>Telescope find_files<CR>')
vim.keymap.set({ 'n' }, '<Plug>(ff)s', '<Cmd>Telescope git_status<CR>')
vim.keymap.set({ 'n' }, '<Plug>(ff)b', '<Cmd>Telescope buffers<CR>')
vim.keymap.set({ 'n' }, '<Plug>(ff)f', '<Cmd>Telescope live_grep<CR>')

-- nvim-lsp
local lsp_config = require('lspconfig')
local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')
local mason_null_ls = require('mason-null-ls')
local null_ls = require('null-ls')

require('dressing').setup()
require('lspsaga').setup()
require('lsp_signature').setup({ hint_enable = false })
require('fidget').setup()

mason.setup()
mason_null_ls.setup({
  ensure_installed = { 'prettier' },
  automatic_installation = true,
})
null_ls.setup({
  sources = { null_ls.builtins.formatting.prettier },
})

mason_lspconfig.setup({
  ensure_installed = {
    'tsserver',
    'eslint',
    'solargraph',
    'ruby_ls',
  },
  automatic_installation = true,
})

mason_lspconfig.setup_handlers({
  function(server_name)
    local opts = {
      capabilities = require('cmp_nvim_lsp').default_capabilities(),
    }

    if server_name == "lua_ls" then
      opts.settings = {
        Lua = {
          diagnostics = { globals = { 'vim' } },
        }
      }
    end
    lsp_config[server_name].setup(opts)
  end,
})

vim.api.nvim_create_autocmd({ 'CursorHold' }, {
  pattern = { '*' },
  callback = function()
    require('lspsaga.diagnostic').show_cursor_diagnostics()
  end,
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'typescript', 'typescriptreact', 'typescript.tsx' },
  callback = function()
    vim.keymap.set({ 'n' }, '<Plug>(lsp)f', function()
      vim.cmd([[EslintFixAll]])
      vim.lsp.buf.format({ name = 'null-ls' })
    end)
  end,
})

local function show_documentation()
  local ft = vim.opt.filetype._value
  if ft == 'vim' or ft == 'help' then
    vim.cmd([[execute 'h ' . expand('<cword>') ]])
  else
    require('lspsaga.hover').render_hover_doc()
  end
end

vim.keymap.set({ 'n' }, 'K', show_documentation)
vim.keymap.set({ 'n' }, '<Plug>(lsp)a', require('lspsaga.codeaction').code_action)
vim.keymap.set({ 'n' }, '<Plug>(lsp)rn', require('lspsaga.rename').rename)
vim.keymap.set({ 'n' }, '<Plug>(lsp)q', '<Cmd>Telescope diagnostics<CR>')
vim.keymap.set({ 'n' }, '<Plug>(lsp)n', require('lspsaga.diagnostic').navigate('next'))
vim.keymap.set({ 'n' }, '<Plug>(lsp)p', require('lspsaga.diagnostic').navigate('prev'))
vim.keymap.set({ 'n' }, '<Plug>(lsp)f', vim.lsp.buf.format)
vim.keymap.set({ 'n' }, '<Plug>(lsp)i', '<Cmd>Telescope lsp_implementations<CR>')
vim.keymap.set({ 'n' }, '<Plug>(lsp)t', '<Cmd>Telescope lsp_type_definitions<CR>')
vim.keymap.set({ 'n' }, '<Plug>(lsp)rf', '<Cmd>Telescope lsp_references<CR>')

-- nvim-cmp
local cmp = require('cmp')
local lspkind = require('lspkind')

cmp.setup({
  enabled = true,
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'nvim_lua' },
    { name = 'luasnip' },
    { name = 'cmdline' },
    { name = 'git' },
  }),
  formatting = {
    fields = { 'abbr', 'kind', 'menu' },
    format = lspkind.cmp_format({
      mode = 'text',
    }),
  },
})

-- fern.vim
vim.keymap.set({ 'n' }, 'td', ':<C-u>Fern . -drawer -reveal=%<CR>')

vim.keymap.set({ 'n' }, '<Leader>e', '<Cmd>Fern . -drawer<CR>')
vim.keymap.set({ 'n' }, '<Leader>E', '<Cmd>Fern . -drawer -reveal=%<CR>')

-- lambdalisue/fern.vim
-- vim.g.fern#renderer = 'nerdfont'
vim.cmd('let g:fern#renderer = "nerdfont"')

vim.api.nvim_create_augroup( 'my-glyph-palette', {} )
vim.api.nvim_create_autocmd('FileType', { pattern = "fern", command = "call glyph_palette#apply()", group = 'my-glyph-palette' })
vim.api.nvim_create_autocmd('FileType', { pattern = "nerdtree,startify", command = "call glyph_palette#apply()", group = 'my-glyph-palette' })

-- vim.cmd(
-- [[
-- function! s:init_fern() abort
--   set nonumber
--   nmap <buffer> o <Plug>(fern-action-open:edit)
--   nmap <buffer> go <Plug>(fern-action-open:edit)<C-w>p
--   nmap <buffer> t <Plug>(fern-action-open:tabedit)
--   nmap <buffer> T <Plug>(fern-action-open:tabedit)gT
--   nmap <buffer> i <Plug>(fern-action-open:split)
--   nmap <buffer> gi <Plug>(fern-action-open:split)<C-w>p
--   nmap <buffer> s <Plug>(fern-action-open:vsplit)
--   nmap <buffer> gs <Plug>(fern-action-open:vsplit)<C-w>p
--   nmap <buffer> ma <Plug>(fern-action-new-path)
--   nmap <buffer> P gg
--
--   nmap <buffer> C <Plug>(fern-action-enter)
--   nmap <buffer> u <Plug>(fern-action-leave)
--   nmap <buffer> r <Plug>(fern-action-reload)
--   nmap <buffer> R gg<Plug>(fern-action-reload)<C-o>
--   nmap <buffer> cd <Plug>(fern-action-cd)
--   nmap <buffer> CD gg<Plug>(fern-action-cd)<C-o>
--
--   nmap <buffer> I <Plug>(fern-action-hidden-toggle)
--
--   nmap <buffer> q :<C-u>quit<CR>
--   nmap <buffer> <C-l> <C-w>l
--
--   nmap <buffer> <Plug>(fern-action-open) <Plug>(fern-action-open:select)
-- endfunction
-- ]])

-- vim.api.nvim_create_augroup('fern-custom', {})
-- vim.api.nvim_create_autocmd('FileType', { pattern = "fern", command = "call s:init_fern()", group = 'fern-custom' })

-- vim.api.nvim_create_augroup('my-fern-startup', {})
-- vim.api.nvim_create_autocmd('VimEnter', { pattern = "*", nested = true, command = "Fern . -drawer -reveal=% -stay", group = 'my-fern-startup' })

-- treesitter
require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'typescript',
    'tsx',
  },
  highlight = {
    enable = true,
    disable = {
      'toml',
      'c_sharp',
    },
  },
})


-- vim.opt.clipboard = "unnamedplus"
vim.opt.clipboard:append{'unnamedplus'}

vim.opt.encoding="UTF-8"

-- default setting
vim.keymap.set({ 'n' }, ';', ':')
vim.opt.sh = 'bash'
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.showmatch = true
-- set matchpairs+=<:>
-- vim.opt.matchpairs = '<:>'
vim.opt.matchtime = 1
vim.opt.relativenumber = true
vim.opt.confirm = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
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
vim.opt.expandtab = true
-- set tags+=.git/tags
vim.opt.mouse= ""
--
-- search
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.keymap.set({ 'n' }, '<Esc><Esc>', ':nohlsearch<CR>', { silent = true })
vim.opt.modeline = true
vim.opt.modelines = 10
vim.opt.inccommand = 'split'

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

-- input mod keymap
vim.keymap.set({ 'i' }, '<C-j>', '<Down>')
vim.keymap.set({ 'i' }, '<C-k>', '<Up>')
vim.keymap.set({ 'i' }, '<C-h>', '<Left>')
vim.keymap.set({ 'i' }, '<C-l>', '<Right>')

-- terminal mode keymap
vim.keymap.set({ 't' }, '<ESC>', '<C-\\><C-n>')
vim.keymap.set({ 't' }, '<C-s>', '<Nop>')

vim.opt.sidescroll = 1
vim.opt.ttimeoutlen = 10

if vim.fn.has('persistent_undo') == 1 then
  if not vim.fn.isdirectory(vim.env.HOME .. '/.vim/undodir') then
    vim.fn.mkdir(vim.env.HOME .. '/.vim/undodir', 'p', 0700)
  end
  vim.opt.undodir = vim.env.HOME .. '/.vim/undodir'
  vim.opt.undofile = true
end

vim.keymap.set({ 'n' }, 'Y', 'y$')
vim.keymap.set({ 'n' }, 'x', '"_x')
vim.keymap.set({ 'n' }, 'xp', '"0x"0p')
vim.keymap.set({ 'n' }, 'cw', '"_cw')
vim.keymap.set({ 'n' }, 'ce', '"_ce')

-- " ビジュアルモード時vで行末まで選択
-- vnoremap v $h
vim.keymap.set({ 'v' }, 'v', '$h')
-- " ビジュアルモードyank後最後の行に移動
vim.keymap.set({ 'v' }, 'y', 'y`>')
-- " ddでレジスタを更新しても対応
vim.keymap.set({ 'n' }, 'PP', '"0p')

-- if has('mac')
--   set clipboard+=unnamedplus
-- endif
--
-- Tab
vim.keymap.set({ 'n' }, 't', '<Nop>')
vim.keymap.set({ 'n' }, 'tt', ':<C-u>tabnew<CR>:tabmove<CR>', { silent = true })
vim.keymap.set({ 'n' }, 'tw', ':<C-u>tabclose<CR>', { silent = true })
vim.keymap.set({ 'n' }, 'tn', ':<C-u>tabnext<CR>', { silent = true })
vim.keymap.set({ 'n' }, 'tp', ':<C-u>tabprevious<CR>', { silent = true })
-- tag のリンクを tabで開く
vim.keymap.set({ 'n' }, 'tj', ":<C-u>tab stjump <C-R>=expand('<cword>')<CR><CR>zz", { silent = true })

-- 日付追加
vim.keymap.set({ 'i' }, ',df', "strftime('%Y-%m-%d %H:%M')", {expr = true})
vim.keymap.set({ 'i' }, ',dd', "strftime('%Y-%m-%d')", {expr = true})
vim.keymap.set({ 'i' }, ',dt', "strftime('%H:%M')", {expr = true})

-- filetype of ruby
-- autocmd BufNewFile,BufRead *.jbuilder set filetype=ruby
-- autocmd BufNewFile,BufRead .pryrc     set filetype=ruby
-- autocmd FileType ruby setl iskeyword+=?

-- " sudo権限で保存
-- cnoremap w!! w !sudo tee > /dev/null %<CR>
--
-- augroup fileTypeIndent
--   autocmd!
--   autocmd BufNewFile, BufRead *.tsv setlocal noexpandtab
-- augroup END
--
-- autocmd ColorScheme * highlight NormalFloat ctermbg=17 guibg=#374549
vim.opt.termguicolors = true
vim.cmd.colorscheme('zephyr')
