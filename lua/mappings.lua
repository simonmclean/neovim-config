local map = vim.api.nvim_set_keymap
local noremap = {noremap=true}
local silent_noremap = {noremap=true, silent=true}

-- Leader
vim.g.mapleader = " "

-- Window control
map('n', '|', ':vertical split<cr>', silent_noremap)
map('n', '-', ':split<cr>', silent_noremap)

-- Lazy exec mode
map('n', ';', ':', noremap)
map('v', ';', ':', noremap)

-- Jumps
map('n', '[q', ':cprevious<cr>', {})
map('n', ']q', ':cnext<cr>', {})

-- Toggle between 2 buffers
map('n', '<leader><leader>', '<c-^>', noremap)

-- Add empty line above or below cursor
map('n', '<leader>k', ':call append(line(".")-1, "")<cr>', silent_noremap)
map('n', '<leader>j', ':call append(line("."), "")<cr>', silent_noremap)

-- Replace motion
map('n', '<leader>p', ':set operatorfunc=ReplaceMotion<cr>g@', silent_noremap)

-- Tryptic
-- map('n', '<leader>-', ':Tryptic<cr>', silent_noremap)
