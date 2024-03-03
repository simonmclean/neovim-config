local tbl_deep_extend = vim.tbl_deep_extend
local capabilities_with_cmp = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

local is_mason_lspconfig_installed, mason_lsp_config = pcall(require, 'mason-lspconfig')
local servers = {}
if is_mason_lspconfig_installed then
  servers = mason_lsp_config.get_installed_servers()
end

-- nvim-lsp-installer must be setup before nvim-lspconfig
-- See https://github.com/williamboman/nvim-lsp-installer#setup
require('mason').setup {
  ui = {
    border = 'single',
  },
}
mason_lsp_config.setup {
  ensure_installed = servers,
  automatic_installation = true,
}
require('lspconfig.ui.windows').default_options.border = 'single'
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local map = function(keys, func, desc)
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
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
  map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

  -- Fuzzy find all the symbols in your current workspace
  --  Similar to document symbols, except searches over your whole project.
  map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- Rename the variable under your cursor
  --  Most Language Servers support renaming across files, etc.
  map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

  -- Execute a code action, usually your cursor needs to be on top of an error
  -- or a suggestion from your LSP for this to activate.
  map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  -- Opens a popup that displays documentation about the word under your cursor
  --  See `:help K` for why this keymap
  map('K', vim.lsp.buf.hover, 'Hover Documentation')

  -- WARN: This is not Goto Definition, this is Goto Declaration.
  --  For example, in C this would take you to the header
  map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  map('<space>f', '<cmd>lua vim.lsp.buf.format { async = true} <CR>', '[F]ormat')
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
-- These will be merged with a default config in the loop below
local config_overrides = {
  eslint = require 'lsp/eslint',
  tsserver = require 'lsp/tsserver',
  lua_ls = require 'lsp/lua',
}
for _, language_server in pairs(servers) do
  local default_config = {
    on_attach = on_attach,
    capabilities = capabilities_with_cmp,
  }
  local lsp_config = require('lspconfig')[language_server]
  if config_overrides[language_server] then
    local custom_config = tbl_deep_extend('keep', config_overrides[language_server], default_config)
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
require 'lsp/metals'(on_attach, capabilities_with_cmp)

-- Add border to all LSP popups
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = 'single'
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- Diagnostic signs
local signs = { Error = '', Warn = '', Hint = '', Info = '' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Custom handler for hover. This acts like the default handler, except it won't print "No information available" when there's no hover info
vim.lsp.handlers['textDocument/hover'] = function(_, result, ctx, config)
  config = config or {}
  config.focus_id = ctx.method
  if not (result and result.contents) then
    return
  end
  local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
  markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
  if vim.tbl_isempty(markdown_lines) then
    return
  end
  return vim.lsp.util.open_floating_preview(markdown_lines, 'markdown', config)
end
