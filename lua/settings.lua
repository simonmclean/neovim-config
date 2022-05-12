-- Init commands
vim.cmd('set termguicolors')
vim.cmd('set shortmess-=F')

-- Colourscheme theme
-- vim.cmd('let g:lightline = {"colorscheme": "blue-moon"}')
-- vim.cmd('colorscheme blue-moon')
-- vim.cmd('let g:lightline = {"colorscheme": "nightfly"}')
-- vim.cmd('colorscheme nightfly')
-- vim.g.lightline = { colorscheme = 'sonokai' }
-- vim.g.sonokai_style = 'maia'
-- vim.g.colors_name = 'sonokai'
vim.g.lightline = { colorscheme = 'tokyonight' }
vim.cmd("colorscheme tokyonight")

-- General options
vim.o.laststatus=3
vim.o.clipboard='unnamed'
vim.o.ignorecase=true
vim.o.smartcase=true
vim.o.showcmd=true
vim.o.showmode=false -- the mode is already displayed in the statusline
vim.o.hidden=true

-- Window options
vim.wo.signcolumn='yes'
vim.wo.cursorline=true
vim.wo.number=true
vim.wo.relativenumber=true
vim.wo.wrap=false

-- Buffer options
