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

  local function finish()
    handle.message = 'Done'
    handle:finish()
    git.update_ahead_behind()
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
          u.system(pull_command, function()
            finish()
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
          u.system(checkout_command, function()
            finish()
          end)
        end)
      end
    end)
  end)
end, { desc = 'Switch to the main branch and pull the latest changes' })

-- Push new branch
create_cmd('PushNew', function()
  local fetch_cmd = 'Git fetch'

  local handle = require('fidget.progress').handle.create {
    title = 'Pushing new remote branch',
    message = 'Running ' .. fetch_cmd,
    lsp_client = { name = 'Git' },
    percentage = 0,
  }

  u.system(fetch_cmd, function()
    u.system('git rev-parse --abbrev-ref HEAD', function(curret_branch)
      handle:report {
        message = 'Checking upstream',
        percentage = 25,
      }
      u.system('git rev-parse --abbrev-ref ' .. curret_branch .. '@{u}', function(upstream_status)
        if string.find(upstream_status, 'fatal: no upstream') then
          handle:report {
            message = 'Pushing to new origin',
            percentage = 50,
          }
          u.system('git push -u origin ' .. curret_branch, function(push_result)
            handle.message = 'Done'
            handle:finish()
            git.update_ahead_behind()
            vim.notify(push_result)
          end)
        else
          handle.message = 'Remote branch already exists'
          handle.percentage = 100
          handle:cancel()
          git.update_ahead_behind()
        end
      end)
    end)
  end)
end, { desc = "Push to a new remote origin (if one doesn't already exist)" })

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
