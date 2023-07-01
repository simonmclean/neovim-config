local _ = require 'utils'

local vim_exec = _.vim_exec
local api = vim.api

--------------------------------------------------------------------------
-- Settings
--------------------------------------------------------------------------

-- General options
vim.o.termguicolors = true
vim.o.laststatus = 3
vim.o.clipboard = 'unnamed'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.showcmd = true
vim.o.showmode = false -- the mode is already displayed in the statusline
vim.o.hidden = true
vim.o.undofile = true
vim.o.scrolloff = 1

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

-- Checkout up-to-date master or main branch
create_cmd('Main', function()
  local main_branch = _.remove_linebreaks(
    vim.fn.system("git remote show origin | grep 'HEAD branch' | cut -d' ' -f5")
  )
  local current_branch_name = _.remove_linebreaks(
    vim.fn.system('git rev-parse --abbrev-ref HEAD')
  )
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

-- TODO: completion doesn't seem to work
-- TODO: handle errors
create_cmd('FindAndReplace',
  function()
    vim.ui.input({ prompt = 'Find: ' }, function(find)
      if (find and find ~= "") then
        vim.ui.input({ prompt = 'Replace with: ' }, function(replace_with)
          if (replace_with and replace_with ~= "") then
            vim.ui.input({ prompt = 'In (e.g. **/*.scala): ', completion = 'dir' }, function(location)
              if (location and location ~= "") then
                vim.ui.input({ prompt = 'Replace "' .. find .. '" with "' .. replace_with .. '" in ' .. location .. '? (enter to confirm, esc to cancel)' },
                  function(answer)
                    if (answer) then
                      -- see :h :s_flags for flag ecplanations
                      vim.cmd('vimgrep /' .. find .. '/gj ' .. location)
                      vim.cmd('cfdo %s/' .. find .. '/' .. replace_with .. '/ge | update')
                    end
                  end)
              end
            end)
          end
        end)
      end
    end)
  end,
  {}
)

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

map('n', '<leader>/', 'yiw:%S/<C-r>"/', { desc = 'Substitue word or selection' }) -- Capital S uses abolish.vim
map('v', '<leader>/', 'y:s/<C-r>"/', { desc = 'Substitue word or selection' })

-- Unwrap something. e.g. if the cursor is in `Foo`, `Foo(Bar)` will become `Bar`
map('n', '<leader>u', 'diwmz%x`zx', { desc = 'Unwrap' })

-- Persisted sessions
map('n', '<leader>s', ':Telescope persisted<CR>', { desc = 'Telescope persisted' })
