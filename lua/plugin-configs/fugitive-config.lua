local u = require 'utils'

return function()
  vim.api.nvim_create_autocmd('User', {
    pattern = { 'FugitiveObject', 'FugitiveIndex' },
    callback = function()
      if u.is_git_repo() then
        u.update_git_status()
      end
    end,
  })
end
