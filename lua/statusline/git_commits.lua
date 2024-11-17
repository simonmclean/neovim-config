-- Module that checks how many commits ahead and behind the local branch is
-- compared to remote. This provides the data for statusline/components/git_ahead_behind.lua

local u = require 'utils'
local git = require 'git'

local UPDATE_FREQUENCY_SECONDS = 60

local StatuslineCommits = {}

StatuslineCommits.new = function()
  local instance = {}
  setmetatable(instance, { __index = StatuslineCommits })
  instance.last_updated_epoch_seconds = nil
  instance.is_updating = false

  if git.is_cwd_a_git_repo() then
    vim.loop.new_timer():start(
      0,
      UPDATE_FREQUENCY_SECONDS * 1000,
      vim.schedule_wrap(function()
        instance:update()
      end)
    )
  end

  return instance
end

---@param prev GitAheadBehindCount
---@param current GitAheadBehindCount
local function warn_if_behind(prev, current)
  if (not prev and current.behind > 0) or (prev and current.behind > prev.behind) then
    vim.schedule(function()
      u.fidget_notify('Local branch is ' .. current.behind .. ' commits behind remote', 'warn')
    end)
  end
end

function StatuslineCommits:update()
  if not git.is_cwd_a_git_repo() or self.is_updating then
    return
  end

  self.is_updating = true

  u.system('git fetch', function()
    git.count_ahead_behind(function(result)
      self.is_updating = false
      self.last_updated_epoch_seconds = os.time()
      warn_if_behind(vim.g.git_ahead_behind_count, result)
      vim.g.git_ahead_behind_count = result
    end)
  end)
end

return {
  new = StatuslineCommits.new,
}
