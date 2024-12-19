local git = require 'git'

local create_cmd = vim.api.nvim_create_user_command

create_cmd('Main', git.main, { desc = 'Switch to the main branch and pull the latest changes' })

create_cmd('GitSync', git.sync, { desc = 'Sync the current git project, doing fetch, pull and push as needed' })

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
