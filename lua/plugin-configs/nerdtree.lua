local map = vim.api.nvim_set_keymap

map('n', '<leader>-', ':NERDTreeFind<cr>', {})
map('n', '<leader>=', ':NERDTreeClose<cr>', {})

vim.g.NERDTreeWinSize = '45'
