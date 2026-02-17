return {
  'lambdalisue/glyph-palette.vim',
  {
    'lambdalisue/fern.vim',
    keys = {
      { "td", "<Cmd>Fern . -drawer -reveal=%<CR>" },
    },
    init = function()
      vim.g["fern#renderer"] = 'nerdfont'

      vim.api.nvim_create_augroup('my-glyph-palette', {})
      vim.api.nvim_create_autocmd('FileType', { pattern = "fern", command = "call glyph_palette#apply()", group = 'my-glyph-palette' })
      vim.api.nvim_create_autocmd('FileType', { pattern = "nerdtree,startify", command = "call glyph_palette#apply()", group = 'my-glyph-palette' })

      vim.api.nvim_create_augroup('fern-custom', {})
      vim.api.nvim_create_autocmd('FileType', {
        pattern = "fern",
        group = 'fern-custom',
        callback = function()
          vim.opt.number = false
          local opts = { silent = true, buffer = true, noremap = false }
          local key = vim.keymap

          key.set({ 'n' }, 'o', '<Plug>(fern-action-open:edit)', opts)
          key.set({ 'n' }, 'go', '<Plug>(fern-action-open:edit)<C-w>p', opts)
          key.set({ 'n' }, 't', '<Plug>(fern-action-open:tabedit)', opts)
          key.set({ 'n' }, 'T', '<Plug>(fern-action-open:tabedit)gT', opts)
          key.set({ 'n' }, 'v', '<Plug>(fern-action-open:split)', opts)
          key.set({ 'n' }, 'gv', '<Plug>(fern-action-open:split)<C-w>p', opts)
          key.set({ 'n' }, 's', '<Plug>(fern-action-open:vsplit)', opts)
          key.set({ 'n' }, 'gs', '<Plug>(fern-action-open:vsplit)<C-w>p', opts)
          key.set({ 'n' }, 'ma', '<Plug>(fern-action-new-path)', opts)
          key.set({ 'n' }, 'P', 'gg', opts)
          key.set({ 'n' }, 'C', '<Plug>(fern-action-enter)', opts)
          key.set({ 'n' }, 'u', '<Plug>(fern-action-leave)', opts)
          key.set({ 'n' }, 'r', '<Plug>(fern-action-reload)', opts)
          key.set({ 'n' }, 'R', 'gg<Plug>(fern-action-reload)<C-o>', opts)
          key.set({ 'n' }, 'cd', '<Plug>(fern-action-cd)', opts)
          key.set({ 'n' }, 'CD', 'gg<Plug>(fern-action-cd)<C-o>', opts)
          key.set({ 'n' }, 'I', '<Plug>(fern-action-hidden-toggle)', opts)
          key.set({ 'n' }, 'q', '<Cmd>quit<CR>', opts)
          key.set({ 'n' }, '<C-l>', '<C-w>l', opts)
          key.set({ 'n' }, '<Plug>(fern-action-open)', '<Plug>(fern-action-open:select)', opts)
          -- fern-preview
          key.set({ 'n' }, 'p', '<Plug>(fern-action-preview:toggle)', opts)
          key.set({ 'n' }, '<C-p>', '<Plug>(fern-action-preview:toggle)', opts)
          key.set({ 'n' }, '<C-d>', '<Plug>(fern-action-preview:scroll:down:half)', opts)
          key.set({ 'n' }, '<C-u>', '<Plug>(fern-action-preview:scroll:up:half)', opts)
        end
      })

      vim.api.nvim_create_augroup('my-fern-startup', {})
      vim.api.nvim_create_autocmd('VimEnter', {
        group = 'my-fern-startup',
        pattern = "*",
        nested = true,
        command = "Fern . -drawer -reveal=% -stay"
      })
      vim.api.nvim_create_autocmd('BufEnter', {
        group = 'my-fern-startup',
        pattern = '*',
        callback = function()
          vim.schedule(function()
            local dominated_by_fern = true
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local config = vim.api.nvim_win_get_config(win)
              -- exclude floating windows
              if config.relative == '' then
                local buf = vim.api.nvim_win_get_buf(win)
                local ft = vim.api.nvim_get_option_value('filetype', { buf = buf })
                if ft ~= 'fern' then
                  dominated_by_fern = false
                  break
                end
              end
            end
            if dominated_by_fern then
              vim.cmd('quit')
            end
          end)
        end
      })
    end
  },
  {
    'lambdalisue/fern-renderer-nerdfont.vim',
    dependencies = {
      'lambdalisue/fern.vim',
      'lambdalisue/nerdfont.vim',
      'lambdalisue/fern-git-status.vim'
    },
    config = function()
      vim.g["fern#renderer#nerdfont#indent_markers"] = 1
    end
  },
  {
    'yuki-yano/fern-preview.vim',
    dependencies = { 'lambdalisue/fern.vim' }
  },
}
