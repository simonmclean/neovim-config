local u = require 'utils'
local git = require 'git'

local create_cmd = vim.api.nvim_create_user_command

create_cmd('Main', function()
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
    git.update_ahead_behind()
    git.update_current_branch()
  end

  u.system("git remote show origin | grep 'HEAD branch' | cut -d' ' -f5", function(main_branch)
    u.system('git rev-parse --abbrev-ref HEAD', function(current_branch)
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
end, { desc = 'Switch to the main branch and pull the latest changes' })

create_cmd('GitSync', function()
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
    git.update_ahead_behind()
    git.update_current_branch()
  end

  -- Perform git fetch
  u.system(fetch_cmd, function()
    -- Get current branch name
    u.system('git rev-parse --abbrev-ref HEAD', function(current_branch)
      -- Count number of commits behind remote
      u.system('git rev-list --count HEAD..@{upstream}', function(number_of_commits_behind_upstream)
        -- If there is no remote, push to a new branch, notify and finish
        if string.find(number_of_commits_behind_upstream, 'fatal: no upstream') then
          handle:report {
            message = 'Pushing to new origin',
            percentage = 50,
          }
          u.system('git push -u origin ' .. current_branch, function(push_result)
            finish(true)
            vim.notify(push_result)
          end)
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

                    return vim.fn.confirm(
                      'Are you sure you want to push directly to "' .. main_branch .. '" branch?',
                      '&Yes\n&No',
                      2
                    ) == 1
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
end, { desc = 'Sync the current git project, doing fetch, pull and push as needed' })

create_cmd('TabWidth', function()
  vim.ui.input({ prompt = 'How many spaces? ', completion = 'command' }, function(arg)
    local n = tonumber(arg)
    vim.bo.tabstop = n
    vim.bo.shiftwidth = n
    vim.bo.expandtab = true
  end)
end, {})

vim.api.nvim_create_user_command('Diff', function(opts)
  vim.cmd.tabnew()
  vim.api.nvim_set_option_value('filetype', opts.args, { buf = 0 })
  vim.cmd.vnew()
  vim.api.nvim_set_option_value('filetype', opts.args, { buf = 0 })
  vim.cmd 'windo diffthis'
end, {
  nargs = 1,
  complete = 'filetype',
  desc = 'Diff <filetype> - open a tab with 2 splits of given filetype and start a diffthis',
})
