return function()
  local autocmd_group = vim.api.nvim_create_augroup('FugitiveHooks', {})

  vim.api.nvim_create_autocmd('User', {
    pattern = { 'FugitiveChanged' },
    group = autocmd_group,
    callback = function()
      if vim.g.statusline_commits_update then
        vim.g.statusline_commits_update()
      end
      if vim.g.update_current_branch_async then
        vim.g.update_current_branch_async()
      end
    end,
  })
end
