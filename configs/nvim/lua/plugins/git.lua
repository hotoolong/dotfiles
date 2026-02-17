return {
  {
    'rhysd/git-messenger.vim',
    keys = {
      { ",gm", "<Plug>(git-messenger)" },
    },
    init = function()
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
    init = function ()
      vim.cmd([[cnoreabbrev Blame TigBlame]])
    end
  },
  {
    'rhysd/conflict-marker.vim',
    init = function()
      -- default mapping
      -- ct :ConflictMarkerThemselves
      -- co :ConflictMarkerOurselves
      -- cb :ConflictMarkerBoth
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
}
