local Job = require 'plenary.job'
local u = require 'utils'

-- Module that creates 2 global variables:
-- vim.g.statusline_commits - Text for the statusline showing how many commits ahead and behind the current local branch is from its remote
-- vim.g.statusline_commits_update - Function to trigger an update of the above statusline variable

---@type { ahead: number, behind: number } | nil
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
          ahead = tonumber(ahead),
          behind = tonumber(behind),
        }
      else
        callback { ahead = 0, behind = 0 }
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
  instance.is_git_repo = u.eval(function()
    local is_git_installed = type(vim.trim(vim.fn.system 'command -v git')) == 'string'
    if not is_git_installed then
      return false
    end
    return vim.trim(vim.fn.system 'git rev-parse --is-inside-work-tree') == 'true'
  end)

  if instance.is_git_repo then
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

function StatuslineCommits:update()
  if not self.is_git_repo or self.is_updating then
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
      vim.g.statusline_commits = result
    end)
  end)
end

return {
  new = StatuslineCommits.new,
}
