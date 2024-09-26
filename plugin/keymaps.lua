local map = require 'utils'.keymap_set

-- Window control
map('n', '|', ':vertical split<cr>')
map('n', '-', ':split<cr>')

-- Scroll
map('n', '<C-k>', '5<C-y>', { desc = 'scroll up' })
map('n', '<C-j>', '5<C-e>', { desc = 'scroll down' })

-- Tab
map('n', '<C-l>', 'gt', { desc = 'tab right' })
map('n', '<C-h>', 'gT', { desc = 'tab left' })

-- Lazy exec mode
-- These can't silent, otherwise the fancy pop-up command line won't appear
map('n', ';', ':', { silent = false })
map('v', ';', ':', { silent = false })

-- Terminal
map('t', '<Esc>', '<C-\\><C-n>', { desc = 'Normal mode from terminal' })

-- Jumps
map('n', '[q', ':cprevious<cr>')
map('n', ']q', ':cnext<cr>')
map('n', '[b', ':bprevious<cr>')
map('n', ']b', ':bnext<cr>')
map('n', ']d', '<cmd>lua vim.diagnostic.goto_next({ float = { border = "single" } })<CR>')
map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev({ float = { border = "single" } })<CR>')

-- Toggle between 2 buffers
map('n', '<leader><leader>', '<c-^>', { desc = 'Previous buffer' })

-- Add empty line above or below cursor
map('n', '<leader>k', ':call append(line(".")-1, "")<cr>', { desc = 'Empty line below' })
map('n', '<leader>j', ':call append(line("."), "")<cr>', { desc = 'Empty line above' })

-- Replace motion
map('n', '<leader>p', ':set operatorfunc=ReplaceMotion<cr>g@', { desc = 'Replace motion' })

map('n', '<leader>/', 'yiw:%S/<C-r>"/', { desc = 'Substitue word or selection' }) -- Capital S uses abolish.vim
map('v', '<leader>/', 'y:s/<C-r>"/', { desc = 'Substitue word or selection' })

-- Unwrap something. e.g. if the cursor is in `Foo`, `Foo(Bar)` will become `Bar`
map('n', '<leader>u', 'diwmz%x`zx', { desc = 'Unwrap' })

map('n', '<leader>gt', function()
  require 'features.goto_test'()
end)

-- When pasting over a visual selection, send the replaced text into the black hole register
map('x', 'p', '"_dp', { noremap = true, silent = true })
map('x', 'P', '"_dP', { noremap = true, silent = true })

-- Exclude block navigation from the jumplist
vim.cmd 'nnoremap <silent> } :<C-u>execute "keepjumps norm! " . v:count1 . "}"<CR>'
vim.cmd 'nnoremap <silent> { :<C-u>execute "keepjumps norm! " . v:count1 . "{"<CR>'

map('n', '<leader>w', function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = 'Toggle wrap' })

-- Makes cursor navigation more intuitive in wrapped text
map('n', 'j', 'gj', { silent = true, desc = 'cursor down' })
map('n', 'k', 'gk', { silent = true, desc = 'cursor up' })
