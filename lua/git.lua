local u = require 'utils'

local M = {}

---@alias GitAheadBehindCount { ahead: integer, behind: integer, remote_exists: boolean }

---count how many commits ahead and behind the local branch is compared to the remote (if it exists)
---@param callback fun(result: GitAheadBehindCount)
function M.count_ahead_behind(callback)
  u.system('git rev-list --left-right --count HEAD...@{upstream}', function(response)
    if type(response) == 'string' then
      local ok, ahead, behind = pcall(string.match, response, '(%d+)%s*(%d+)')
      if not ok then
        ahead, behind = 0, 0
        error('Unable to parse response in function count_ahead_behind: ' .. tostring(response))
      end
      callback {
        ahead = tonumber(ahead) or 0,
        behind = tonumber(behind) or 0,
        remote_exists = true,
      }
    else
      callback { ahead = 0, behind = 0, remote_exists = false }
    end
  end)
end

---Run count_ahead_behind() and set the result in vim.g.git_ahead_behind_count
function M.update_ahead_behind()
  M.count_ahead_behind(function(result)
    ---@type GitAheadBehindCount
    vim.g.git_ahead_behind_count = result
    vim.cmd.redrawstatus()
  end)
end

---Update vim.g.git_current_branch_name with the current branch name
function M.update_current_branch()
  u.system('git rev-parse --abbrev-ref HEAD', function(branch)
    -- Remove trailing newline before assigning
    vim.g.git_current_branch_name = string.gsub(branch, '\n$', '')
    vim.cmd.redrawstatus()
  end)
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'VimEnter' }, {
  pattern = '*',
  callback = M.update_current_branch,
})

---Check if current working directory is a git repo. Result is cached
---@return boolean
function M.is_cwd_a_git_repo()
  if vim.g.is_cwd_a_git_repo == nil then
    -- This is deliberately not async
    local is_git_installed = type(vim.trim(vim.fn.system 'command -v git')) == 'string'
    if not is_git_installed then
      vim.g.is_cwd_a_git_repo = false
    else
      vim.g.is_cwd_a_git_repo = vim.trim(vim.fn.system 'git rev-parse --is-inside-work-tree') == 'true'
    end
  end

  return vim.g.is_cwd_a_git_repo
end

return M
