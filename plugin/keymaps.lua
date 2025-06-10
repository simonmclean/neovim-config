local u = require 'utils'

u.keys {
  -- Window control
  { '|', ':vertical split<cr>', 'split vertical' },
  { '-', ':split<cr>', 'split horizontal' },

  -- TabAdd commentMore actions
  { '<C-l>', 'gt', 'tab right' },
  { '<C-h>', 'gT', 'tab left' },

  -- Scroll
  { '<C-k>', '5<C-y>', 'scroll up' },
  { '<C-j>', '5<C-e>', 'scroll down' },

  -- Lazy exec mode
  -- These can't silent, otherwise the fancy pop-up command line won't appear
  { ';', ':', 'exec mode', modes = { 'n', 'v' }, opts = { silent = false } },

  -- Terminal
  { '<Esc>', '<C-\\><C-n>', 'Normal mode from terminal', modes = 't' },

  -- Jumps
  { ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', 'diagnostic next' },
  { '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', 'diagnostic previous' },

  -- Toggle between 2 buffers
  { '<leader><leader>', '<c-^>', 'Previous buffer' },

  -- Add empty line above or below cursor
  { '<leader>k', ':call append(line(".")-1, "")<cr>', 'Empty line below' },
  { '<leader>j', ':call append(line("."), "")<cr>', 'Empty line above' },

  { '<leader>/', 'yiw:%S/<C-r>"/', 'Substitue word or selection' }, -- Capital S uses abolish.vim
  { '<leader>/', 'y:s/<C-r>"/', 'Substitue word or selection', modes = 'v' },

  { '<C-/>', ':nohlsearch<CR>', 'Clear search highlight' },

  { '<leader>T', '<cmd>GotoTest<CR>', 'Go to test' },

  -- When pasting over a visual selection, send the replaced text into the black hole register
  { 'p', '"_dp', 'paste ahead', modes = 'x' },
  { 'P', '"_dP', 'paste before', modes = 'x' },

  -- Makes cursor navigation more intuitive in wrapped text
  { 'j', 'gj', 'cursor down' },
  { 'k', 'gk', 'cursor down' },

  -- Exclude block navigation from the jumplist
  {

    '}',
    function()
      vim.cmd 'execute "keepjumps norm! " .. v:count1 .. "}"'
    end,
    'block next',
  },
  {

    '{',
    function()
      vim.cmd 'execute "keepjumps norm! " .. v:count1 .. "{"'
    end,
    'block previous',
  },

  -- LSP rename
  { '<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame' },

  -- LSP code action
  { '<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction' },

  -- Replace motion e.g. <leader>pq performs "paste in quotes"
  {

    '<leader>p',
    function()
      _G.Replace = function(selection_type)
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

      vim.o.operatorfunc = 'v:lua._G.Replace'
      -- Trigger the function defined in operatorfunc
      vim.api.nvim_feedkeys('g@', 'n', false)
    end,
    'Replace motion',
  },
}
