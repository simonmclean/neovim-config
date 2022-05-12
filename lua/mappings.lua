local map = vim.keymap.set
local silent = { silent = true }

-- Leader
vim.g.mapleader = " "

-- Window control
map('n', '|', ':vertical split<cr>', silent)
map('n', '-', ':split<cr>', silent)

-- Lazy exec mode
map('n', ';', ':')
map('v', ';', ':')

-- Jumps
map('n', '[q', ':cprevious<cr>')
map('n', ']q', ':cnext<cr>')
map('n', '[b', ':bprevious<cr>')
map('n', ']b', ':bnext<cr>')

-- Toggle between 2 buffers
map('n', '<leader><leader>', '<c-^>', silent)

-- Add empty line above or below cursor
map('n', '<leader>k', ':call append(line(".")-1, "")<cr>', silent)
map('n', '<leader>j', ':call append(line("."), "")<cr>', silent)

-- Replace motion
map('n', '<leader>p', ':set operatorfunc=ReplaceMotion<cr>g@', silent)

-- Tryptic
-- map('n', '<leader>-', ':Tryptic<cr>', silent_noremap)
