return {
  {
    'stevearc/dressing.nvim',
    config = true,
  },
  'sainnhe/gruvbox-material',
  {
    'glepnir/zephyr-nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
  {
    'rebelot/kanagawa.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      theme = "dragon",
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      sections = {
        lualine_c = {
          {
            'filename',
            path = 1,
          }
        }
      }
    }
  },
  {
    "shellRaining/hlchunk.nvim",
    event = { "UIEnter" },
    opts = {
      chunk = {
        chars = {
          horizontal_line = "─",
          vertical_line = "│",
          left_top = "╭",
          left_bottom = "╰",
          right_arrow = ">",
        },
        style = "#806d9c",
      },
      blank = {
        enable = false
      }
    }
  },
  { 'rcarriga/nvim-notify' },
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
}
