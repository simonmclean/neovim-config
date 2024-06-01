local u = require 'utils'

local create_cmd = vim.api.nvim_create_user_command

-- Checkout up-to-date master or main branch
create_cmd('Main', function()
  local main_branch = u.remove_linebreaks(vim.fn.system "git remote show origin | grep 'HEAD branch' | cut -d' ' -f5")
  local current_branch_name = u.remove_linebreaks(vim.fn.system 'git rev-parse --abbrev-ref HEAD')
  local pull_command = 'Git pull'

  if current_branch_name == main_branch then
    -- If already on main, just fetch and pull latest
    local update_command = 'Git fetch --prune'
    vim.cmd(update_command .. ' | ' .. pull_command)
  else
    -- If not on main, first update main branch, then checkout
    local update_command = 'Git fetch --prune origin ' .. main_branch .. ':' .. main_branch
    local checkout_command = 'Git checkout ' .. main_branch
    vim.cmd(update_command .. ' | ' .. checkout_command)
  end
end, {})

-- Push new branch
create_cmd('PushNew', function()
  vim.cmd 'Git fetch'
  local current_branch_name = u.remove_linebreaks(vim.fn.system 'git rev-parse --abbrev-ref HEAD')
  local upstream_status = vim.fn.system('git rev-parse --abbrev-ref ' .. current_branch_name .. '@{u}')
  if string.find(upstream_status, 'fatal: no upstream') then
    vim.cmd('Git push -u origin ' .. current_branch_name)
  else
    vim.notify('Remote branch already exists', vim.log.levels.WARN)
  end
end, {})

create_cmd('LuaPrint', function()
  vim.ui.input({ prompt = 'Enter lua to evaluate: ', completion = 'command' }, function(input)
    vim.cmd('lua vim.print(' .. input .. ')')
  end)
end, {})

create_cmd('TabWidth', function()
  vim.ui.input({ prompt = 'How many spaces? ', completion = 'command' }, function(arg)
    local n = tonumber(arg)
    vim.bo.tabstop = n
    vim.bo.shiftwidth = n
    vim.bo.expandtab = true
  end)
end, {})

