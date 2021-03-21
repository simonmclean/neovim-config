-- Init commands
vim.cmd('set termguicolors')
vim.cmd('set shortmess-=F')

-- Apply theme
-- vim.cmd('let g:lightline = {"colorscheme": "blue-moon"}')
-- vim.cmd('colorscheme blue-moon')
-- vim.cmd('let g:lightline = {"colorscheme": "nightfly"}')
-- vim.cmd('colorscheme nightfly')
vim.cmd('let g:lightline = {"colorscheme": "sonokai"}')
vim.cmd('let g:sonokai_style = "maia"')
vim.cmd('colorscheme sonokai')

-- General options
vim.o.clipboard='unnamed'
vim.o.ignorecase=true
vim.o.smartcase=true
vim.o.showcmd=true
vim.o.showmode=false -- the mode is already displayed in the statusline

-- Window options
vim.wo.signcolumn='yes'
vim.wo.cursorline=true
vim.wo.number=true
vim.wo.relativenumber=true
vim.wo.wrap=false

-- Buffer options
