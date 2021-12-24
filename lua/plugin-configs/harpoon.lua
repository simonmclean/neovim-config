vim.cmd 'autocmd FileType harpoon set wrap'

local map = vim.api.nvim_set_keymap
local opts = { noremap=true, silent=true }

map('n', '<leader>ha', '<cmd>lua require("harpoon.mark").add_file()<cr>', opts)
map('n', '<leader>hh', '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', opts)

map('n', '<leader>h1', '<cmd>lua require("harpoon.ui").nav_file(1)()<cr>', opts)
map('n', '<leader>h2', '<cmd>lua require("harpoon.ui").nav_file(2)()<cr>', opts)
map('n', '<leader>h3', '<cmd>lua require("harpoon.ui").nav_file(3)()<cr>', opts)
map('n', '<leader>h4', '<cmd>lua require("harpoon.ui").nav_file(4)()<cr>', opts)
map('n', '<leader>h5', '<cmd>lua require("harpoon.ui").nav_file(5)()<cr>', opts)

map('n', '[h', '<cmd>lua require("harpoon.ui").nav_prev()<cr>', opts)
map('n', ']h', '<cmd>lua require("harpoon.ui").nav_next()<cr>', opts)

