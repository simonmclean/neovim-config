local u = require 'utils'
local su = require 'statusline.utils'
local icons = require 'icons'
local git = require 'git'

require 'statusline.git_commits'.new()

return su.conditional_component(git.is_cwd_a_git_repo(), function()
  local state = vim.g.git_ahead_behind_count
  if state then
    if state.remote_exists then
      return u.trim_string(u.list_join({
        icons.up_arrow,
        tostring(state.ahead),
        icons.down_arrow,
        tostring(state.behind),
      }, ' '))
    else
      return '(no remote)'
    end
  else
    return icons.up_arrow .. ' - ' .. icons.down_arrow .. ' -'
  end
end)
