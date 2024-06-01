--------------------------------------------------------------------------
-- Global options
--------------------------------------------------------------------------
vim.o.termguicolors = true
vim.o.laststatus = 3
vim.o.clipboard = 'unnamed'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.showcmd = true
vim.o.showmode = false -- the mode is already displayed in the statusline
vim.o.hidden = true
vim.o.undofile = true
vim.o.scrolloff = 10
vim.o.smoothscroll = true
vim.opt_global.shortmess:append 's'
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.g.foldtext = function()
  local line = vim.fn.getline(vim.v.foldstart)
  local folded_line_count = vim.v.foldend - vim.v.foldstart + 1
  return '--[' .. folded_line_count .. ' lines] ' .. line
end
vim.opt.fillchars = { fold = ' ', foldopen = '', foldclose = '' }
vim.o.foldcolumn = 'auto'
vim.o.inccommand = 'split'
vim.o.confirm = true

--------------------------------------------------------------------------
-- Window options
--------------------------------------------------------------------------
vim.wo.signcolumn = 'yes'
vim.wo.cursorline = true
vim.wo.number = true
vim.wo.relativenumber = false
vim.wo.wrap = false

