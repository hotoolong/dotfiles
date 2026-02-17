return {
  { 'vim-jp/vimdoc-ja', ft = 'help' },
  'ryanoasis/vim-devicons',
  'moll/vim-node',
  'pangloss/vim-javascript',
  'mattn/emmet-vim',
  'othree/html5.vim',
  'dag/vim-fish',
  { 'jghauser/mkdir.nvim' },
  {
    "ph1losof/shelter.nvim",
    lazy = false,
    opts = {},
  },
  {
    'sheerun/vim-polyglot',
    init = function()
      vim.g.polyglot_disabled = { 'rbs' }
    end
  },
}
