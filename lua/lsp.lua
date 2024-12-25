local u = require 'utils'
local icons = require 'icons'

local M = {}

local signs = { Error = icons.error, Warn = icons.warn, Hint = icons.hint, Info = icons.info }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
M.on_attach = function(_, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', { buf = bufnr })

  u.keys {
    -- Jump to the definition of the word under your cursor.
    --  This is where a variable was first declared, or where a function is defined, etc.
    --  To jump back, press <C-T>.
    { 'gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition', opts = { buffer = bufnr } },

    -- Find references for the word under your cursor.
    { 'gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences', opts = { buffer = bufnr } },

    -- Jump to the implementation of the word under your cursor.
    --  Useful when your language has ways of declaring types without an actual implementation.
    { 'gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation', opts = { buffer = bufnr } },

    -- Jump to the type of the word under your cursor.
    --  Useful when you're not sure what type a variable is and you want to see
    --  the definition of its *type*, not where it was *defined*.
    { '<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition', opts = { buffer = bufnr } },

    -- Fuzzy find all the symbols in your current document.
    --  Symbols are things like variables, functions, types, etc.
    {
      '<leader>ss',
      require('telescope.builtin').lsp_document_symbols,
      '[S]earch [D]ocument Symbols',
      opts = { buffer = bufnr },
    },

    -- Fuzzy find all the symbols in your current workspace
    --  Similar to document symbols, except searches over your whole project.
    {
      '<leader>sws',
      require('telescope.builtin').lsp_dynamic_workspace_symbols,
      '[S]earch [W]orkspace [S]ymbols',
      opts = { buffer = bufnr },
    },

    -- Rename the variable under your cursor
    --  Most Language Servers support renaming across files, etc.
    { '<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame', opts = { buffer = bufnr } },

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    { '<leader>ca', require('actions-preview').code_actions, '[C]ode [A]ction', opts = { buffer = bufnr } },

    -- WARN: This is not Goto Definition, this is Goto Declaration.
    --  For example, in C this would take you to the header
    { 'gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration', opts = { buffer = bufnr } },
  }
end

M.capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

return M
