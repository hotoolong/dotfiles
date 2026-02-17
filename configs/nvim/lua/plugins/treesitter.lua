return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    branch = 'master',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          'bash',
          'css',
          'csv',
          'fish',
          'git_config',
          'git_rebase',
          'gitcommit',
          'gitignore',
          'graphql',
          'html',
          'javascript',
          'jq',
          'json',
          'lua',
          'make',
          'markdown',
          'python',
          'rbs',
          'ruby',
          'scss',
          'sql',
          'ssh_config',
          'toml',
          'typescript',
          'vim',
          'vimdoc',
          'vue',
          'yaml',
        },
        sync_install = true,
        indent = {
          enable = true,
        }
      })
    end
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
}
