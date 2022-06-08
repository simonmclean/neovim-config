local utils = require 'utils'

local vim_exec = utils.vim_exec

--------------------------------------------------------------------------
-- Settings
--------------------------------------------------------------------------

-- Init commands
-- TODO: Set these options in lua instead of vimscript
vim.cmd('set termguicolors')
vim.cmd('set shortmess-=F')

-- Colourscheme theme
-- vim.cmd('colorscheme blue-moon')
-- vim.cmd('colorscheme nightfly')
-- vim.g.sonokai_style = 'maia'
-- vim.g.colors_name = 'sonokai'
-- vim.cmd("colorscheme tokyonight")
vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
vim.cmd('colorscheme catppuccin')

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
  vim.cmd('Git checkout ' .. main_branch .. ' | Git fetch --prune | Git pull', true)
end

local function git_push_new_remote()
  vim.cmd('Git fetch')
  local current_branch_name = utils.remove_linebreaks(vim.fn.system('git rev-parse --abbrev-ref HEAD'))
  local upstream_status = vim.fn.system('git rev-parse --abbrev-ref ' .. current_branch_name .. '@{u}')
  if string.find(upstream_status, 'fatal: no upstream') then
    vim.cmd('Git push -u origin ' .. current_branch_name)
  else
    print("Error: Remote branch already exists")
  end
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

-- Push new branch
create_cmd('PushNew', git_push_new_remote, {})

--------------------------------------------------------------------------
-- Abbreviations
--------------------------------------------------------------------------

local create_abbr = function(abbr, cmd)
  local str = 'iabbr ' .. abbr .. ' ' .. cmd
  vim.api.nvim_exec(str, false)
end

create_abbr('clog', [[console.log();<Left><Left><C-R>=Eatchar('\s')<CR>]])
create_abbr('vpp', [[vim.pretty_print()<Left><C-R>=Eatchar('\s')<CR>]])

--------------------------------------------------------------------------
-- Autocommands
--------------------------------------------------------------------------

local my_augroup = vim.api.nvim_create_augroup("SimonMcLeanBootstrap", { clear = true })

local create_autocmd = vim.api.nvim_create_autocmd

-- Remove trailing whitespace on save
create_autocmd('BufWritePre', {
  callback = function()
    vim_exec([[%s/\s\+$//e]])
  end,
  group = my_augroup
})

-- Disable cursorline in quickfix
create_autocmd('FileType', {
  pattern = 'qf',
  command = 'setlocal nocursorline',
  group = my_augroup
})

-- Auto install treesitter parsers
create_autocmd('FileType', {
  group = my_augroup,
  callback = function()
    local parsers = require 'nvim-treesitter.parsers'
    local lang = parsers.get_buf_lang()
    if (parsers.get_parser_configs()[lang] and not parsers.has_parser(lang)) then
      vim.schedule_wrap(function()
        vim.cmd('TSInstall ' .. lang)
      end)
    end
  end
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
vim.cmd('nnoremap <silent> } :<C-u>execute "keepjumps norm! " . v:count1 . "}"<CR>')
vim.cmd('nnoremap <silent> { :<C-u>execute "keepjumps norm! " . v:count1 . "{"<CR>')

-- Shortcut for substitute
map('n', '<leader>/', ':%s/')
map('v', '<leader>/', ':s/')

-- Persisted sessions
map('n', '<leader>s', ':Telescope persisted<CR>')
