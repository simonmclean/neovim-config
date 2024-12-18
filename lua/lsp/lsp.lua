local capabilities_with_cmp = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local keymap_set = require('utils').keymap_set

require('lspconfig.ui.windows').default_options.border = 'single'

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', { buf = bufnr })

  local map = function(keys, func, desc)
    keymap_set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
  end

  -- Jump to the definition of the word under your cursor.
  --  This is where a variable was first declared, or where a function is defined, etc.
  --  To jump back, press <C-T>.
  map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

  -- Find references for the word under your cursor.
  map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

  -- Jump to the implementation of the word under your cursor.
  --  Useful when your language has ways of declaring types without an actual implementation.
  map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

  -- Jump to the type of the word under your cursor.
  --  Useful when you're not sure what type a variable is and you want to see
  --  the definition of its *type*, not where it was *defined*.
  map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

  -- Fuzzy find all the symbols in your current document.
  --  Symbols are things like variables, functions, types, etc.
  map('<leader>ss', require('telescope.builtin').lsp_document_symbols, '[S]earch [D]ocument Symbols')

  -- Fuzzy find all the symbols in your current workspace
  --  Similar to document symbols, except searches over your whole project.
  map('<leader>sws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[S]earch [W]orkspace [S]ymbols')

  -- Rename the variable under your cursor
  --  Most Language Servers support renaming across files, etc.
  map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

  -- Execute a code action, usually your cursor needs to be on top of an error
  -- or a suggestion from your LSP for this to activate.
  map('<leader>ca', require('actions-preview').code_actions, '[C]ode [A]ction')

  -- WARN: This is not Goto Definition, this is Goto Declaration.
  --  For example, in C this would take you to the header
  map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
end

local mason_lsp_config = require 'mason-lspconfig'

local servers = mason_lsp_config.get_installed_servers()

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
-- These will be merged with a default config in the loop below
local config_overrides = {
  lua_ls = require 'lsp.language-servers.lua',
}

for _, language_server in pairs(servers) do
  local default_config = {
    on_attach = on_attach,
    capabilities = capabilities_with_cmp,
  }
  local lsp_config = require('lspconfig')[language_server]
  if config_overrides[language_server] then
    local custom_config = vim.tbl_deep_extend('keep', config_overrides[language_server], default_config)
    if custom_config.on_attach_extend then
      custom_config.on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        custom_config.on_attach_extend(client, bufnr)
      end
    end
    lsp_config.setup(custom_config)
  else
    lsp_config.setup(default_config)
  end
end

-- Metals is initialized separately, because it's a special snowflake
require 'lsp.language-servers.metals'(on_attach, capabilities_with_cmp)

-- Diagnostic signs
local signs = { Error = '', Warn = '', Hint = '', Info = '' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
