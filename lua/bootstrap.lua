local _ = require 'utils'

local vim_exec = _.vim_exec
local api = vim.api

--------------------------------------------------------------------------
-- Settings
--------------------------------------------------------------------------

-- Init commands
-- TODO: Set these options in lua instead of vimscript
vim.cmd('set termguicolors')

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
vim.o.undofile = true

-- Window options
vim.wo.signcolumn = 'yes'
vim.wo.cursorline = true
vim.wo.number = true
vim.wo.relativenumber = false
vim.wo.wrap = false
vim.g.mapleader = " "

--------------------------------------------------------------------------
-- Custom commands
--------------------------------------------------------------------------

local create_cmd = api.nvim_create_user_command

-- Source init.lua
-- TODO: This doesn't always work as intended because it doesn't reload modules...
create_cmd('Source', ':luafile ~/.config/nvim/init.lua', {})

-- Open init.lua
create_cmd('Config', ':e ~/.config/nvim/init.lua', {})

-- Checkout up-to-date master branch
create_cmd('Main', function()
  local main_branch = vim.fn.system("git remote show origin | grep 'HEAD branch' | cut -d' ' -f5")
  main_branch = main_branch:gsub("%s+", "")
  vim.cmd('Git fetch --prune | Git checkout ' .. main_branch .. ' |  Git pull', true)
end, {})

-- Push new branch
create_cmd('PushNew', function()
  vim.cmd('Git fetch')
  local current_branch_name = _.remove_linebreaks(vim.fn.system('git rev-parse --abbrev-ref HEAD'))
  local upstream_status = vim.fn.system('git rev-parse --abbrev-ref ' .. current_branch_name .. '@{u}')
  if string.find(upstream_status, 'fatal: no upstream') then
    vim.cmd('Git push -u origin ' .. current_branch_name)
  else
    print("Error: Remote branch already exists")
  end
end, {})

create_cmd('LuaPrint', function()
  vim.ui.input({ prompt = 'Enter lua to evaluate: ', completion = 'command' }, function(input)
    vim.cmd('lua vim.pretty_print(' .. input .. ')')
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
vim.cmd('nnoremap <silent> } :<C-u>execute "keepjumps norm! " . v:count1 . "}"<CR>')
vim.cmd('nnoremap <silent> { :<C-u>execute "keepjumps norm! " . v:count1 . "{"<CR>')

--------------------------------------------------------------------------
-- Autocommands
--------------------------------------------------------------------------

local my_augroup = api.nvim_create_augroup("SimonMcLeanBootstrap", { clear = true })

local create_autocmd = api.nvim_create_autocmd

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
-- Tabline
--------------------------------------------------------------------------

-- TODO: Windows count, click handlers, handle icons plugin not being installed
_G.my_custom_tabline = function()
  local tabs = api.nvim_list_tabpages()
  local current_tab = api.nvim_get_current_tabpage()
  -- For each tab check if it's the currently focused one
  local with_is_active = _.list_map(tabs, function(tab_id)
    return {
      tab_id = tab_id,
      is_active = tab_id == current_tab
    }
  end)
  -- For each tab get the focused window
  local with_win_id = _.list_map(with_is_active, function(tab)
    tab['win_id'] = api.nvim_tabpage_get_win(tab.tab_id)
    return tab
  end)
  -- For each window get buffer info
  local with_buf_data = _.list_map(with_win_id, function(tab)
    local buf_id = api.nvim_win_get_buf(tab.win_id)
    tab['buf_id'] = buf_id
    tab['buf_name'] = api.nvim_buf_get_name(buf_id)
    tab['buf_filetype'] = api.nvim_buf_get_option(buf_id, 'filetype')
    return tab
  end)
  -- For each tab set the title
  local with_tab_titles = _.list_map(with_buf_data, function(tab)
    local filename = _.last(_.split_string(tab.buf_name, '/'))
    local icon = _.eval(function()
      local icons_package = require 'nvim-web-devicons'
      if (tab.buf_filetype and icons_package) then
        local icon = icons_package.get_icon_by_filetype(tab.buf_filetype)
        if (icon) then
          return icon .. ' '
        end
        return ''
      end
    end)
    if (filename == "") then
      if (tab.buf_filetype == "") then
        tab['title'] = '[empty tab]'
      else
        tab['title'] = icon .. tab.buf_filetype
      end
    else
      tab['title'] = icon .. filename
    end
    return tab
  end)
  -- Create the tabline strings, including highlight groups
  local tabline_strings = _.list_map(with_tab_titles, function(tab)
    local highlight_group
    if (tab.is_active) then
      highlight_group = '%#TabLineSel#'
    else
      highlight_group = '%#TabLine#'
    end
    return highlight_group .. ' ' .. tab.title .. ' '
  end)
  local tabline = _.list_join(tabline_strings) .. '%#TabLineFill#%='
  return tabline
end

vim.o.tabline = '%!v:lua.my_custom_tabline()'

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

-- Toggle between 2 buffers
map('n', '<leader><leader>', '<c-^>', { silent = true, desc = 'Previous buffer' })

-- Add empty line above or below cursor
map('n', '<leader>k', ':call append(line(".")-1, "")<cr>', { silent = true, desc = 'Empty line below' })
map('n', '<leader>j', ':call append(line("."), "")<cr>', { silent = true, desc = 'Empty line above' })

-- Replace motion
map('n', '<leader>p', ':set operatorfunc=ReplaceMotion<cr>g@', { silent = true, desc = 'Replace motion' })

map('n', '<leader>/', 'yiw:%s/<C-r>"/', { desc = 'Substitue word or selection' })
map('v', '<leader>/', 'y:s/<C-r>"/', { desc = 'Substitue word or selection' })

-- Unwrap something. e.g. if the cursor is in `Foo`, `Foo(Bar)` will become `Bar`
map('n', '<leader>u', 'diwmz%x`zx', { desc = 'Unwrap' })

-- Persisted sessions
map('n', '<leader>s', ':Telescope persisted<CR>', { desc = 'Telescope persisted' })
