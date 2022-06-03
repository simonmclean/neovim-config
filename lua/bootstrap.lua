local utils = require'utils'

local vim_exec = utils.vim_exec

--------------------------------------------------------------------------
-- Settings
--------------------------------------------------------------------------

-- Init commands
-- TODO: Set these options in lua instead of vimscript
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
vim.o.laststatus = 3
vim.o.clipboard = 'unnamed'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.showcmd = true
vim.o.showmode = false -- the mode is already displayed in the statusline
vim.o.hidden = true

-- Window options
vim.wo.signcolumn = 'yes'
vim.wo.cursorline = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.wrap = false

--------------------------------------------------------------------------
-- Functions
--------------------------------------------------------------------------

local function checkout_latest_master()
  local main_branch = vim.fn.system("git remote show origin | grep 'HEAD branch' | cut -d' ' -f5")
  main_branch = main_branch:gsub("%s+", "")
  vim_exec('Git checkout ' .. main_branch .. ' | Git fetch --prune | Git pull', false)
end

--------------------------------------------------------------------------
-- Custom commands
--------------------------------------------------------------------------

local create_cmd = vim.api.nvim_create_user_command

-- Source init.lua
-- TODO: This doesn't always work as intended because it doesn't reload modules...
create_cmd('Source', ':luafile ~/.config/nvim/init.lua', {})

-- Open init.lua
create_cmd('Config', ':e ~/.config/nvim/init.lua', {})

-- Checkout up-to-date master branch
create_cmd('Main', checkout_latest_master, {})

-- Restore previous session for the current directory
create_cmd('Restore', function() require 'persistence'.load() end, {})

--------------------------------------------------------------------------
-- Abbreviations
--------------------------------------------------------------------------

local create_abbr = function(abbr, cmd)
  local str = 'iabbr ' .. abbr .. ' ' .. cmd
  vim.api.nvim_exec(str, false)
end

create_abbr('clog', [[console.log();<Left><Left><C-R>=Eatchar('\s')<CR>]])
create_abbr('vpp', [[vim.pretty_print();<Left><Left><C-R>=Eatchar('\s')<CR>]])

--------------------------------------------------------------------------
-- Autocommands
--------------------------------------------------------------------------

vim.api.nvim_create_augroup("SimonMcLeanBootstrap", { clear = true })

local create_autocmd = vim.api.nvim_create_autocmd

-- Remove trailing whitespace on save
create_autocmd('BufWritePre', {
  callback = function()
    print('boom')
    vim.api.nvim_exec([[%s/\s\+$//e]], false)
  end,
  group = 'SimonMcLeanBootstrap'
})

-- Disable cursorline in quickfix
create_autocmd('Filetype', {
  pattern = 'qf',
  command = 'setlocal nocursorline',
  group = 'SimonMcLeanBootstrap'
})

--------------------------------------------------------------------------
-- Mappings
--------------------------------------------------------------------------

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

-- Exclude block navigation from the jumplist
-- TODO: Write this binding using lua instead of vimscript
vim.cmd('nnoremap <silent> } :<C-u>execute "keepjumps norm! " . v:count1 . "}"<CR>')
vim.cmd('nnoremap <silent> { :<C-u>execute "keepjumps norm! " . v:count1 . "{"<CR>')
