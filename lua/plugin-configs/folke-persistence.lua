local persistence_augroup = vim.api.nvim_create_augroup("SimonMcLeanPersistence", { clear = true })

-- Automatically restore previous session
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.schedule(function() require'persistence'.load() end)
  end,
  group = persistence_augroup
})
