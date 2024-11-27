local u = require 'statusline.utils'
local icons = require 'icons'
local git = require 'git'

return u.conditional_component(git.is_cwd_a_git_repo(), function()
  local name = vim.g.git_current_branch_name
  if name then
    return icons.git .. ' ' .. vim.g.git_current_branch_name
  end
end)
