return function()
  local autocmd_group = vim.api.nvim_create_augroup('FugitiveHooks', {})

  vim.api.nvim_create_autocmd('User', {
    pattern = { 'FugitiveObject', 'FugitiveIndex' },
    group = autocmd_group,
    callback = function()
      if vim.g.statusline_commits_update then
        vim.g.statusline_commits_update()
      end
    end,
  })
end
