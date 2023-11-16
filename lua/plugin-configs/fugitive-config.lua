local u = require 'utils'

return function()
  local autocmd_group = vim.api.nvim_create_augroup('FugitiveHooks', {})

  vim.api.nvim_create_autocmd('User', {
    pattern = { 'FugitiveObject', 'FugitiveIndex' },
    group = autocmd_group,
    callback = function()
      if u.is_git_repo() then
        u.update_git_status()
      end
    end,
  })
end
