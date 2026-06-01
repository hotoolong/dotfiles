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
    "y3owk1n/undo-glow.nvim",
    event = { "VeryLazy" },
    opts = {
      animation = {
        enabled = true,
        duration = 300,
        animation_type = "zoom",
        window_scoped = true,
      },
      highlights = {
        undo = { hl_color = { bg = "#693232" } },
        redo = { hl_color = { bg = "#2F4640" } },
        yank = { hl_color = { bg = "#7A683A" } },
        paste = { hl_color = { bg = "#325B5B" } },
        search = { hl_color = { bg = "#5C475C" } },
        cursor = { hl_color = { bg = "#793D54" } },
      },
      priority = 2048 * 3,
    },
    keys = {
      { "u", function() require("undo-glow").undo() end, mode = "n", desc = "Undo" },
      { "U", function() require("undo-glow").redo() end, mode = "n", desc = "Redo" },
      { "p", function() require("undo-glow").paste_below() end, mode = "n", desc = "Paste below" },
      { "P", function() require("undo-glow").paste_above() end, mode = "n", desc = "Paste above" },
      { "n", function() require("undo-glow").search_next({ animation = { animation_type = "strobe" } }) end, mode = "n", desc = "Search next" },
      { "N", function() require("undo-glow").search_prev({ animation = { animation_type = "strobe" } }) end, mode = "n", desc = "Search prev" },
    },
    init = function()
      vim.api.nvim_create_autocmd("TextYankPost", {
        desc = "Highlight on yank",
        callback = function() require("undo-glow").yank() end,
      })
    end,
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
}
