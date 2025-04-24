local u = require 'utils'

local M = {}

---@alias GitAheadBehindCount { ahead: integer, behind: integer, remote_exists: boolean }

---count how many commits ahead and behind the local branch is compared to the remote (if it exists)
---@param callback fun(result: GitAheadBehindCount)
function M.count_ahead_behind(callback)
  u.system('git rev-list --left-right --count HEAD...@{upstream}', function(response)
    if not string.find(response, 'fatal: no upstream') then
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
  -- This callback is a local check. Doesn't do fetch or anything like that.
  callback = M.update_current_branch,
})

function M.get_current_branch_name(callback)
  u.system('git rev-parse --abbrev-ref HEAD', callback)
end

---Use Fugitive to push.
---If there isn't a remote branch, ask for confirmation before creating one
---If pushing to main/master ask for confirmation
function M.push()
  M.get_current_branch_name(function(current_branch)
    u.system('git rev-parse --abbrev-ref ' .. current_branch .. '@{upstream}', function(response)
      if string.find(response, 'fatal: no upstream') then
        if u.confirm('Push new remote branch "' .. current_branch .. '"?') then
          vim.cmd('Git push --set-upstream origin ' .. current_branch)
        end
      else
        local allow_push = u.eval(function()
          if current_branch == 'main' or current_branch == 'master' then
            return u.confirm 'Push directly to main?'
          end
          return true
        end)
        if allow_push then
          vim.cmd 'Git push'
        end
      end
    end)
  end)
end

---Switch to main/master, fetch and pull latest changes
function M.main()
  local handle = require('fidget.progress').handle.create {
    title = 'Switching to latest main',
    message = 'Getting main branch',
    lsp_client = { name = 'Git' },
    percentage = 0,
  }

  local function error_or_continue(response, callback)
    if string.find(response, 'error:') then
      vim.notify(response, vim.log.levels.WARN)
      handle:cancel()
    else
      callback()
    end
  end

  local function finish()
    handle.message = 'Done'
    handle:finish()
    M.update_ahead_behind()
    M.update_current_branch()
  end

  u.system("git remote show origin | grep 'HEAD branch' | cut -d' ' -f5", function(main_branch)
    M.get_current_branch_name(function(current_branch)
      local pull_command = 'git pull'

      if current_branch == main_branch then
        local update_command = 'git fetch --prune'
        handle:report {
          message = 'Running ' .. update_command,
          percentage = 50,
        }
        u.system(update_command, function()
          handle:report {
            message = 'Running ' .. pull_command,
            percentage = 75,
          }
          u.system(pull_command, function(response)
            error_or_continue(response, finish)
          end)
        end)
      else
        -- If not on main, first update main branch, then checkout
        local update_command = 'git fetch --prune origin ' .. main_branch .. ':' .. main_branch
        handle:report {
          message = 'Running ' .. update_command,
          percentage = 50,
        }
        u.system(update_command, function()
          local checkout_command = 'git checkout ' .. main_branch
          handle:report {
            message = 'Running ' .. update_command,
            percentage = 75,
          }
          u.system(checkout_command, function(response)
            error_or_continue(response, finish)
          end)
        end)
      end
    end)
  end)
end

---Pull and push
function M.sync()
  local fetch_cmd = 'git fetch'

  local handle = require('fidget.progress').handle.create {
    title = 'Syncing project',
    message = 'Running ' .. fetch_cmd,
    lsp_client = { name = 'Git' },
    percentage = 0,
  }

  ---@param success boolean
  local function finish(success)
    if success then
      handle.message = 'Done'
      handle:finish()
    else
      handle:cancel()
    end
    M.update_ahead_behind()
    M.update_current_branch()
  end

  -- Perform git fetch
  u.system(fetch_cmd, function()
    -- Get current branch name
    M.get_current_branch_name(function(current_branch)
      -- Count number of commits behind remote
      u.system('git rev-list --count HEAD..@{upstream}', function(number_of_commits_behind_upstream)
        -- If there is no remote, push to a new branch, notify and finish
        if string.find(number_of_commits_behind_upstream, 'fatal: no upstream') then
          if u.confirm('Push new remote branch "' .. current_branch .. '"?') then
            handle:report {
              message = 'Pushing to new origin',
              percentage = 50,
            }
            u.system('git push -u origin ' .. current_branch, function(push_result)
              finish(true)
              vim.notify(push_result)
            end)
          end
        else
          -- Count number of commits ahead of remote
          u.system('git rev-list --count @{upstream}..HEAD', function(number_of_commits_ahead_of_upstream)
            local ahead = tonumber(number_of_commits_ahead_of_upstream)
            local behind = tonumber(number_of_commits_behind_upstream)

            local push_if_ahead = function()
              if ahead > 0 then
                -- Get the main branch name
                u.system("git remote show origin | grep 'HEAD branch' | cut -d' ' -f5", function(main_branch)
                  -- If we're on the main branch, ask for confirmation before pushing
                  local allow_push = u.eval(function()
                    if current_branch ~= main_branch then
                      return true
                    end

                    return u.confirm('Are you sure you want to push directly to "' .. main_branch .. '" branch?')
                  end)

                  if allow_push then
                    local push_cmd = 'git push'
                    handle:report {
                      message = 'Running ' .. push_cmd,
                      percentage = 75,
                    }
                    u.system(push_cmd, function()
                      finish(true)
                    end)
                  else
                    finish(true)
                  end
                end)
              else
                finish(true)
              end
            end

            -- If we're behind the remote, then pull first
            if behind > 0 then
              local pull_cmd = 'git pull'
              handle:report {
                message = 'Running ' .. pull_cmd,
                percentage = 50,
              }
              u.system(pull_cmd, function(pull_response)
                -- If we can't pull due to local changes, notify and finish
                if string.find(pull_response, 'error:') then
                  vim.notify(pull_response, vim.log.levels.WARN)
                  finish(false)
                else
                  -- If we're ahead of remote, then push and finish
                  push_if_ahead()
                end
              end)
            else
              -- If we're not behind, then push and finish
              push_if_ahead()
            end
          end)
        end
      end)
    end)
  end)
end

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
