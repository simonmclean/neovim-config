-- Init commands
vim.cmd('set termguicolors')
vim.cmd('let g:lightline = {"colorscheme": "blue-moon"}')
vim.cmd('colorscheme blue-moon')

-- General options
vim.o.clipboard='unnamed'
vim.o.ignorecase=true
vim.o.smartcase=true
vim.o.showcmd=true

-- Window options
vim.wo.cursorline=true
vim.wo.number=true
vim.wo.relativenumber=true
vim.wo.wrap=false

-- Buffer options
