-- Integration between Mason and lspconfig

local lsp = require 'lsp'

return {
  'williamboman/mason-lspconfig.nvim',
  event = 'VeryLazy',
  dependencies = {
    'folke/neodev.nvim',
    'neovim/nvim-lspconfig',
    'williamboman/mason.nvim',
  },
  ---@module 'mason-lspconfig'
  ---@type MasonLspconfigSettings
  opts = {
    ensure_installed = { 'lua_ls', 'ts_ls' },
    automatic_installation = true,
  },
  config = function()
    local mason_lsp_config = require 'mason-lspconfig'

    local servers = mason_lsp_config.get_installed_servers()

    -- Use a loop to conveniently call 'setup' on multiple servers and
    -- map buffer local keybindings when the language server attaches
    -- These will be merged with a default config in the loop below
    local config_overrides = {
      lua_ls = require 'language-servers.lua',
    }

    for _, language_server in pairs(servers) do
      local default_config = {
        on_attach = lsp.on_attach,
        capabilities = lsp.capabilities_with_cmp,
      }

      local lsp_config = require('lspconfig')[language_server]

      if config_overrides[language_server] then
        local custom_config = vim.tbl_deep_extend('keep', config_overrides[language_server], default_config)

        if custom_config.on_attach_extend then
          custom_config.on_attach = function(client, bufnr)
            lsp.on_attach(client, bufnr)
            custom_config.on_attach_extend(client, bufnr)
          end
        end

        lsp_config.setup(custom_config)
      else
        lsp_config.setup(default_config)
      end
    end
  end,
}
