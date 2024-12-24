-- Signcolumn icons for git
-- Manage hunks (stage, unstage, undo, preview etc)

return {
  'lewis6991/gitsigns.nvim',
  event = 'VeryLazy',
  config = function()
    local u = require 'utils'

    require('gitsigns').setup {
      on_attach = function(bufnr)
        local git_signs = package.loaded.gitsigns

        u.buf_keys(bufnr, {
          -- Navigation
          {
            ']c',
            function()
              if vim.wo.diff then
                vim.cmd.normal { ']c', bang = true }
              else
                git_signs.nav_hunk 'next'
              end
            end,
            'hunk next',
          },
          {
            '[c',
            function()
              if vim.wo.diff then
                vim.cmd.normal { '[c', bang = true }
              else
                git_signs.nav_hunk 'prev'
              end
            end,
            'hunk previous',
          },
          -- Actions
          { '<leader>hs', git_signs.stage_hunk, 'hunk stage', modes = { 'n', 'v' } },
          { '<leader>hr', git_signs.reset_hunk, 'hunk reset', modes = { 'n', 'v' } },
          { '<leader>hu', git_signs.undo_stage_hunk, 'hunk unstage', modes = { 'n', 'v' } },
          { '<leader>hp', git_signs.preview_hunk, 'hunk previous' },
        })
      end,
    }
  end,
}
