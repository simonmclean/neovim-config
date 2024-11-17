local map = require('utils').keymap_set

-- Window control
map('n', '|', ':vertical split<cr>')
map('n', '-', ':split<cr>')

-- Scroll
map('n', '<C-k>', '5<C-y>', { desc = 'scroll up' })
map('n', '<C-j>', '5<C-e>', { desc = 'scroll down' })

-- Tab
map('n', '<C-l>', 'gt', { desc = 'tab right' })
map('n', '<C-h>', 'gT', { desc = 'tab left' })

-- Lazy exec mode
-- These can't silent, otherwise the fancy pop-up command line won't appear
map('n', ';', ':', { silent = false })
map('v', ';', ':', { silent = false })

-- Terminal
map('t', '<Esc>', '<C-\\><C-n>', { desc = 'Normal mode from terminal' })

-- Jumps
map('n', '[q', ':cprevious<cr>')
map('n', ']q', ':cnext<cr>')
map('n', '[b', ':bprevious<cr>')
map('n', ']b', ':bnext<cr>')
map('n', ']d', '<cmd>lua vim.diagnostic.goto_next({ float = { border = "single" } })<CR>')
map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev({ float = { border = "single" } })<CR>')

-- Toggle between 2 buffers
map('n', '<leader><leader>', '<c-^>', { desc = 'Previous buffer' })

-- Add empty line above or below cursor
map('n', '<leader>k', ':call append(line(".")-1, "")<cr>', { desc = 'Empty line below' })
map('n', '<leader>j', ':call append(line("."), "")<cr>', { desc = 'Empty line above' })

-- Replace motion e.g. <leader>pq performs "paste in quotes"
map('n', '<leader>p', function()
  __Replace = function(selection_type)
    if selection_type ~= 'char' then
      return
    end

    local sel_save = vim.o.selection
    vim.o.selection = 'inclusive'

    -- Visually select the chars we're pasting over
    vim.cmd 'normal! `[v`]'
    -- Delete the visual selection, sending it to the black hole register
    vim.cmd 'silent normal! "_d'
    -- Paste the originally yanked text before the cursor
    vim.cmd 'normal! P'

    vim.o.selection = sel_save
  end

  vim.o.operatorfunc = 'v:lua.__Replace'
  -- Trigger the function defined in operatorfunc
  vim.api.nvim_feedkeys('g@', 'n', false)
end, { desc = 'Replace motion' })

map('n', '<leader>/', 'yiw:%S/<C-r>"/', { desc = 'Substitue word or selection' }) -- Capital S uses abolish.vim
map('v', '<leader>/', 'y:s/<C-r>"/', { desc = 'Substitue word or selection' })

map('n', '<C-/>', ':nohlsearch<CR>', { desc = 'Clear search highlight' })

map('n', '<leader>gt', '<cmd>GotoTest<CR>', { desc = 'Go to test' })

-- When pasting over a visual selection, send the replaced text into the black hole register
map('x', 'p', '"_dp', { noremap = true, silent = true })
map('x', 'P', '"_dP', { noremap = true, silent = true })

-- Exclude block navigation from the jumplist
vim.cmd 'nnoremap <silent> } :<C-u>execute "keepjumps norm! " . v:count1 . "}"<CR>'
vim.cmd 'nnoremap <silent> { :<C-u>execute "keepjumps norm! " . v:count1 . "{"<CR>'

map('n', '<leader>w', function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = 'Toggle wrap' })

-- Makes cursor navigation more intuitive in wrapped text
map('n', 'j', 'gj', { silent = true, desc = 'cursor down' })
map('n', 'k', 'gk', { silent = true, desc = 'cursor up' })

-- Git/Fugitive
map('n', '<leader>gs', ':tab G<CR>', { desc = 'Git status' })
map('n', '<leader>gC', ':tab Git commit<CR>', { desc = 'Git commit' })
map('n', '<leader>gc', ':Telescope git_branches<CR>', { desc = 'Git checkout' })
map('n', '<leader>gf', ':Git fetch<CR>', { desc = 'Git fetch' })
map('n', '<leader>gb', ':GBrowse<CR>', { desc = 'Open git repo in browser' })
map('n', '<leader>gm', ':Main<CR>', { desc = 'Switch to the main branch and pull the latest changes' })
map('n', '<leader>gp', ':GitSync<CR>', { desc = 'Sync the current git project, doing fetch, pull and push as needed' })
