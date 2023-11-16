return function()
  local utils = require 'utils'

  local allowed_dirs = {
    '~/code',
    '~/.config/nvim',
  }

  local ignored_dirs = {
    'node_modules',
  }

  require('persisted').setup {
    autoload = true,
    allowed_dirs = allowed_dirs,
    ignored_dirs = ignored_dirs,
    branch_separator = '_',
  }

  local autocmd_group = vim.api.nvim_create_augroup('PersistedHooks', {})

  vim.api.nvim_create_autocmd('User', {
    pattern = 'PersistedSavePre',
    group = autocmd_group,
    callback = function()
      local filetypes = { 'fugitive', 'Trouble', 'qf' }
      for _, bufid in ipairs(vim.api.nvim_list_bufs()) do
        local filetype = vim.api.nvim_buf_get_option(bufid, 'filetype')
        if utils.list_contains(filetypes, filetype) then
          vim.api.nvim_buf_delete(bufid, {})
        end
      end
    end,
  })
end
