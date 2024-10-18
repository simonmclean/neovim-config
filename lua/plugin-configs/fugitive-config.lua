local git = require 'git'

return {
  -- Git wrapper and lightweight UI
  'tpope/vim-fugitive',
  config = function()
    local autocmd_group = vim.api.nvim_create_augroup('FugitiveHooks', {})

    vim.api.nvim_create_autocmd('User', {
      pattern = { 'FugitiveChanged' },
      group = autocmd_group,
      callback = function()
        git.update_ahead_behind()
        git.update_current_branch()
      end,
    })
  end,
}
