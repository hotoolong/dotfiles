return {
  {
    'folke/trouble.nvim',
    keys = {
      { "<leader>xx", function() require("trouble").toggle() end },
      { "<leader>xw", function() require("trouble").open("workspace_diagnostics") end },
      { "<leader>xd", function() require("trouble").open("document_diagnostics") end },
      { "<leader>xl", function() require("trouble").open("lsp_references") end },
    },
  },
}
