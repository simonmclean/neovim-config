local u = require 'utils'

local M = {}

---Use Fugitive to push.
---If there isn't a remote branch, ask for confirmation before creating one
---If pushing to main/master ask for confirmation
function M.push()
  local current_branch = vim.g.git.repo.branch_local
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
  end

  u.system("git remote show origin | grep 'HEAD branch' | cut -d' ' -f5", function(main_branch)
    local pull_command = 'git pull'

    local current_branch = vim.g.git.repo.branch_local

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
end

return M
