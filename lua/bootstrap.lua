local _ = require 'utils'

local vim_exec = _.vim_exec
local api = vim.api

--------------------------------------------------------------------------
-- Bootstrap plugin manager
--------------------------------------------------------------------------

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

--------------------------------------------------------------------------
-- Settings
--------------------------------------------------------------------------

-- General options
vim.g.mapleader = ' '
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

-- Window options
vim.wo.signcolumn = 'yes'
vim.wo.cursorline = true
vim.wo.number = true
vim.wo.relativenumber = false
vim.wo.wrap = false

--------------------------------------------------------------------------
-- Non-vim Globals
--------------------------------------------------------------------------

UserState = {
  checking_git_status = false,
  git_status = { ahead = 0, behind = 0 },
}

--------------------------------------------------------------------------
-- Custom commands
--------------------------------------------------------------------------

local create_cmd = api.nvim_create_user_command

-- Checkout up-to-date master or main branch
create_cmd('Main', function()
  local main_branch = _.remove_linebreaks(vim.fn.system "git remote show origin | grep 'HEAD branch' | cut -d' ' -f5")
  local current_branch_name = _.remove_linebreaks(vim.fn.system 'git rev-parse --abbrev-ref HEAD')
  local pull_command = 'Git pull'

  if current_branch_name == main_branch then
    -- If already on main, just fetch and pull latest
    local update_command = 'Git fetch --prune'
    vim.cmd(update_command .. ' | ' .. pull_command, true)
  else
    -- If not on main, first update main branch, then checkout
    local update_command = 'Git fetch --prune origin ' .. main_branch .. ':' .. main_branch
    local checkout_command = 'Git checkout ' .. main_branch
    vim.cmd(update_command .. ' | ' .. checkout_command, true)
  end
end, {})

-- Push new branch
create_cmd('PushNew', function()
  vim.cmd 'Git fetch'
  local current_branch_name = _.remove_linebreaks(vim.fn.system 'git rev-parse --abbrev-ref HEAD')
  local upstream_status = vim.fn.system('git rev-parse --abbrev-ref ' .. current_branch_name .. '@{u}')
  if string.find(upstream_status, 'fatal: no upstream') then
    vim.cmd('Git push -u origin ' .. current_branch_name)
  else
    vim.notify('Remote branch already exists', vim.log.levels.WARN)
  end
end, {})

create_cmd('LuaPrint', function()
  vim.ui.input({ prompt = 'Enter lua to evaluate: ', completion = 'command' }, function(input)
    vim.cmd('lua vim.print(' .. input .. ')')
  end)
end, {})

create_cmd('TabWidth', function()
  vim.ui.input({ prompt = 'How many spaces? ', completion = 'command' }, function(arg)
    local n = tonumber(arg)
    vim.bo.tabstop = n
    vim.bo.shiftwidth = n
    vim.bo.expandtab = true
  end)
end, {})

-- Exclude block navigation from the jumplist
vim.cmd 'nnoremap <silent> } :<C-u>execute "keepjumps norm! " . v:count1 . "}"<CR>'
vim.cmd 'nnoremap <silent> { :<C-u>execute "keepjumps norm! " . v:count1 . "{"<CR>'

--------------------------------------------------------------------------
-- Autocommands
--------------------------------------------------------------------------

local my_augroup = api.nvim_create_augroup('SimonMcLeanBootstrap', { clear = true })

local create_autocmd = api.nvim_create_autocmd

-- Remove trailing whitespace on save
create_autocmd('BufWritePre', {
  callback = function()
    vim_exec [[%s/\s\+$//e]]
  end,
  group = my_augroup,
})

-- Disable cursorline in quickfix
create_autocmd('FileType', {
  pattern = 'qf',
  command = 'setlocal nocursorline',
  group = my_augroup,
})

-- Highlight when yanking (copying) text
-- See `:help vim.highlight.on_yank()`
create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

--------------------------------------------------------------------------
-- Mappings
--------------------------------------------------------------------------

local map = vim.keymap.set
local silent = { silent = true }

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
map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')
map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')

-- Toggle between 2 buffers
map('n', '<leader><leader>', '<c-^>', { silent = true, desc = 'Previous buffer' })

-- Add empty line above or below cursor
map('n', '<leader>k', ':call append(line(".")-1, "")<cr>', { silent = true, desc = 'Empty line below' })
map('n', '<leader>j', ':call append(line("."), "")<cr>', { silent = true, desc = 'Empty line above' })

-- Replace motion
map('n', '<leader>p', ':set operatorfunc=ReplaceMotion<cr>g@', { silent = true, desc = 'Replace motion' })

map('n', '<leader>/', 'yiw:%S/<C-r>"/', { desc = 'Substitue word or selection' }) -- Capital S uses abolish.vim
map('v', '<leader>/', 'y:s/<C-r>"/', { desc = 'Substitue word or selection' })

-- Unwrap something. e.g. if the cursor is in `Foo`, `Foo(Bar)` will become `Bar`
map('n', '<leader>u', 'diwmz%x`zx', { desc = 'Unwrap' })
