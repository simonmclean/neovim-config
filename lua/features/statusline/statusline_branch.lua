vim.g.statusline_branch_name = ''

-- TODO: Add throttling
vim.g.update_current_branch_async = function()
  if not IS_CWD_GIT_REPO then
    return
  end

  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)

  local function onread(err, data)
    if err then
      -- Handle error, for example:
      vim.notify('Error reading git branch: ' .. err, vim.log.levels.ERROR)
    end
    if data then
      -- Assuming data is not nil, update the global variable. Remove trailing newline.
      vim.g.statusline_branch_name = data:gsub('\n$', '')
    end
  end

  local function onexit(code, signal)
    stdout:close()
    stderr:close()
    if code ~= 0 then
      vim.notify('Failed to get git branch with exit code: ' .. code, vim.log.levels.ERROR)
    end
  end

  local handle = vim.loop.spawn(
    'git',
    {
      args = { 'rev-parse', '--abbrev-ref', 'HEAD' },
      stdio = { nil, stdout, stderr },
    },
    vim.schedule_wrap(function(code, signal)
      onexit(code, signal)
    end)
  )

  vim.loop.read_start(stdout, onread)
  vim.loop.read_start(stderr, function() end) -- stderr needs to be consumed even if not used
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'VimEnter' }, {
  pattern = '*',
  callback = function()
    vim.g.update_current_branch_async()
  end,
})
