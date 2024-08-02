local map = vim.keymap.set
local silent = { silent = true }

-- Window control
map('n', '|', ':vertical split<cr>', silent)
map('n', '-', ':split<cr>', silent)

map('n', '<C-k>', '3<C-y>', { desc = 'scroll up' })
map('n', '<C-j>', '3<C-e>', { desc = 'scroll down' })

-- Lazy exec mode
map('n', ';', ':')
map('v', ';', ':')

-- Jumps
map('n', '[q', ':cprevious<cr>')
map('n', ']q', ':cnext<cr>')
map('n', '[b', ':bprevious<cr>')
map('n', ']b', ':bnext<cr>')
map('n', ']d', '<cmd>lua vim.diagnostic.goto_next({ float = { border = "single" } })<CR>')
map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev({ float = { border = "single" } })<CR>')

-- Toggle between 2 buffers
map('n', '<leader><leader>', '<c-^>', { silent = true, desc = 'Previous buffer' })

-- Add empty line above or below cursor
map('n', '<leader>k', ':call append(line(".")-1, "")<cr>', { silent = true, desc = 'Empty line below' })
map('n', '<leader>j', ':call append(line("."), "")<cr>', { silent = true, desc = 'Empty line above' })

-- Replace motion
map('n', '<leader>p', ':set operatorfunc=ReplaceMotion<cr>g@', { silent = true, desc = 'Replace motion' })

map('n', '<leader>/', 'yiw:%S/<C-r>"/', { desc = 'Substitue word or selection' }) -- Capital S uses abolish.vim
map('v', '<leader>/', 'y:s/<C-r>"/', { desc = 'Substitue word or selection' })

-- Unwrap something. e.g. if the cursor is in `Foo`, `Foo(Bar)` will become `Bar`
map('n', '<leader>u', 'diwmz%x`zx', { desc = 'Unwrap' })

map('n', '<leader>gt', function()
  require 'features.goto_test'()
end)

-- Exclude block navigation from the jumplist
vim.cmd 'nnoremap <silent> } :<C-u>execute "keepjumps norm! " . v:count1 . "}"<CR>'
vim.cmd 'nnoremap <silent> { :<C-u>execute "keepjumps norm! " . v:count1 . "{"<CR>'
