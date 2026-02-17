return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      picker = {
        enabled = true,
        win = {
          input = {
            keys = {
              ["<Esc>"] = { "close", mode = { "n", "i" } },
              ["<C-g>"] = { "close", mode = { "n", "i" } },
              ["<C-j>"] = { "list_down", mode = { "i" } },
              ["<C-k>"] = { "list_up", mode = { "i" } },
            },
          },
        },
      },
      notifier = { enabled = false },
      dashboard = { enabled = false },
    },
    keys = {
      { "<Plug>(ff)f", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<Plug>(ff)g", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<Plug>(ff)G", function() Snacks.picker.resume() end, desc = "Resume" },
      { "<Plug>(ff)m", function() Snacks.picker.recent() end, desc = "Recent Files" },
      { "<Plug>(ff)s", function() Snacks.picker.git_status() end, desc = "Git Status" },
      { "<Plug>(ff)b", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<Plug>(ff)h", function() Snacks.picker.help() end, desc = "Help Tags" },
      -- LSP
      { "<Plug>(lsp)q", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<Plug>(lsp)i", function() Snacks.picker.lsp_implementations() end, desc = "LSP Implementations" },
      { "<Plug>(lsp)t", function() Snacks.picker.lsp_type_definitions() end, desc = "LSP Type Definitions" },
      { "<Plug>(lsp)rf", function() Snacks.picker.lsp_references() end, desc = "LSP References" },
    },
  },
}
