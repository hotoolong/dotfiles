return {
  'tomtom/tcomment_vim',
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-treesitter/nvim-treesitter-textobjects' },
    config = true
  },
  {
    'simeji/winresizer',
    init = function()
      vim.g.winresizer_start_key = '<C-z>'
    end
  },
  {
    'thinca/vim-quickrun',
    cmd = 'QuickRun',
    keys = {
      { '\\r', '<Cmd>write<CR><Cmd>QuickRun<CR>', { silent = true } },
    },
    init = function()
      vim.g.quickrun_config = {
        _ = { runner = "neovim_job" },
        rspec = {
          command = "rspec",
          exec = 'bundle exec %c --no-color %s',
          filetype = 'rspec-result'
        },
        ['rspec.line'] = {
          command = 'rspec',
          exec = 'bundle exec %c %s:%a',
          filetype = 'rspec-result'
        }
      }
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
      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = { "javascript" },
        callback = function()
          vim.b.switch_custom_definitions = {
            { 'let', 'const' },
            { '===', '!==' },
          }
        end
      })
      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = { "ruby.rspec" },
        callback = function()
          vim.b.switch_custom_definitions = {
            { 'be_falsey', 'be_truthy' },
          }
        end
      })
    end
  },
  {
    'hotoolong/translate.nvim',
    init = function()
      vim.g.translate_copy_result = 1
    end
  },
  {
    "nvim-neotest/neotest",
    lazy = true,
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "olimorris/neotest-rspec",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-rspec")
        },
      })
    end
  },
  'pechorin/any-jump.vim',
  'mattn/vim-maketable',
}
