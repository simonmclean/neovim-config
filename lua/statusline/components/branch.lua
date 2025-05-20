local icons = require 'icons'

return function()
  if vim.g.git.state == 'READY' then
    return string.format('%s %s', icons.git, vim.g.git.repo.branch_local)
  end
end
