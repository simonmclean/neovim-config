local Job = require 'plenary.job'

-- Module that creates 2 global variables:
-- vim.g.statusline_commits - Text for the statusline showing how many commits ahead and behind the current local branch is from its remote
-- vim.g.statusline_commits_update - Function to trigger an update of the above statusline variable

---@class GitCommitsStatus
---@field ahead integer
---@field behind integer
---@field remote_exists boolean

---@type GitCommitsStatus | nil
vim.g.statusline_commits = nil

local UPDATE_FREQUENCY_SECONDS = 60
local UPDATE_THROTTLE_SECONDS = 10

local function git_fetch(callback)
  Job:new({
    command = 'git',
    args = { 'fetch' },
    on_exit = callback,
  }):start()
end

---@param callback fun(status: GitCommitsStatus): nil
local function git_check_commits_diff(callback)
  Job:new({
    command = 'git',
    args = { 'rev-list', '--left-right', '--count', 'HEAD...@{upstream}' },
    on_exit = function(job, _)
      local response = job:result()[1]
      if type(response) == 'string' then
        local ok, ahead, behind = pcall(string.match, response, '(%d+)%s*(%d+)')
        if not ok then
          ahead, behind = 0, 0
          error('Unable to parse response in function check_ahead_behind: ' .. tostring(response))
        end
        callback {
          ahead = tonumber(ahead) or 0,
          behind = tonumber(behind) or 0,
          remote_exists = true
        }
      else
        callback { ahead = 0, behind = 0, remote_exists = false }
      end
    end,
  }):start()
end

local StatuslineCommits = {}

StatuslineCommits.new = function()
  local instance = {}
  setmetatable(instance, { __index = StatuslineCommits })
  instance.last_updated_epoch_seconds = nil
  instance.is_updating = false

  if IS_CWD_GIT_REPO then
    vim.loop.new_timer():start(
      0,
      UPDATE_FREQUENCY_SECONDS * 1000,
      vim.schedule_wrap(function()
        instance:update()
      end)
    )
  end

  vim.g.statusline_commits_update = function()
    instance:update()
  end

  return instance
end

---@param prev GitCommitsStatus
---@param current GitCommitsStatus
local function warn_if_behind(prev, current)
  if (not prev and current.behind > 0) or (prev and current.behind > prev.behind) then
    vim.schedule(function()
      vim.notify('Local branch is ' .. current.behind .. ' commits behind remote', vim.log.levels.WARN)
    end)
  end
end

function StatuslineCommits:update()
  if not IS_CWD_GIT_REPO or self.is_updating then
    return
  end

  local now_seconds = os.time()
  local should_update = not self.last_updated_epoch_seconds
    or (self.last_updated_epoch_seconds and now_seconds - self.last_updated_epoch_seconds > UPDATE_THROTTLE_SECONDS)
  if not should_update then
    return
  end

  self.is_updating = true

  git_fetch(function()
    git_check_commits_diff(function(result)
      self.is_updating = false
      self.last_updated_epoch_seconds = os.time()
      warn_if_behind(vim.g.statusline_commits, result)
      vim.g.statusline_commits = result
    end)
  end)
end

return {
  new = StatuslineCommits.new,
}
