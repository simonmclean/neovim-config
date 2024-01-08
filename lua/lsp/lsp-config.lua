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

vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ac', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ac', '<cmd>lua vim.cmd("CodeActionMenu")<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.format { async = true} <CR>', opts)
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
