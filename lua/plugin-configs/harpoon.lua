require('harpoon').setup({
	menu = {
		width = 120,
	}
})

vim.cmd 'autocmd FileType harpoon setlocal wrap'

local map = vim.api.nvim_set_keymap
local opts = { noremap=true, silent=true }

map('n', '<backspace>', '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', opts)
map('n', '<leader>m', '<cmd>lua require("harpoon.mark").add_file()<cr>', opts)

map('n', '<leader>1', '<cmd>lua require("harpoon.ui").nav_file(1)()<cr>', opts)
map('n', '<leader>2', '<cmd>lua require("harpoon.ui").nav_file(2)()<cr>', opts)
map('n', '<leader>3', '<cmd>lua require("harpoon.ui").nav_file(3)()<cr>', opts)
map('n', '<leader>4', '<cmd>lua require("harpoon.ui").nav_file(4)()<cr>', opts)
map('n', '<leader>5', '<cmd>lua require("harpoon.ui").nav_file(5)()<cr>', opts)


map('n', '[h', '<cmd>lua require("harpoon.ui").nav_prev()<cr>', opts)
map('n', ']h', '<cmd>lua require("harpoon.ui").nav_next()<cr>', opts)

