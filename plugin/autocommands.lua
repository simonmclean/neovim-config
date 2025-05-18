local my_augroup = vim.api.nvim_create_augroup('SimonMcLeanBootstrap', { clear = true })

local create_autocmd = vim.api.nvim_create_autocmd

-- Remove trailing whitespace on save
create_autocmd('BufWritePre', {
  callback = function()
    vim.api.nvim_exec2([[%s/\s\+$//e]], {})
  end,
  group = my_augroup,
})

-- Disable cursorline in quickfix
create_autocmd('FileType', {
  pattern = 'qf',
  command = 'setlocal nocursorline',
  group = my_augroup,
})

-- Highlight when yanking (copying) text
-- See `:help vim.highlight.on_yank()`
create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = my_augroup,
  callback = function()
    vim.highlight.on_yank()
  end,
})
