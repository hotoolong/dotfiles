return {
  {
    'nvimtools/none-ls.nvim',
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require('null-ls')
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.completion.spell,
          null_ls.builtins.completion.tags,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.diagnostics.erb_lint,
          null_ls.builtins.diagnostics.fish,
          null_ls.builtins.diagnostics.reek,
          null_ls.builtins.diagnostics.rubocop.with({
            prefer_local = "bundle_bin",
            condition = function(utils)
              return utils.root_has_file({".rubocop.yml"})
            end
          }),
        },
      })
    end
  },
  {
    'jayp0521/mason-null-ls.nvim',
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      'nvimtools/none-ls.nvim',
      "williamboman/mason.nvim",
    },
    opts = {
      handlers = {}
    }
  },
}
