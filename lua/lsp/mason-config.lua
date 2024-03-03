return function(on_attach, capabilities)
  -- nvim-lsp-installer must be setup before nvim-lspconfig
  -- See https://github.com/williamboman/nvim-lsp-installer#setup
  require('mason').setup {
    ui = {
      border = 'single',
    },
  }

  local mason_lsp_config = require 'mason-lspconfig'

  local servers = mason_lsp_config.get_installed_servers()

  mason_lsp_config.setup {
    ensure_installed = servers,
    automatic_installation = true,
  }

  -- Use a loop to conveniently call 'setup' on multiple servers and
  -- map buffer local keybindings when the language server attaches
  -- These will be merged with a default config in the loop below
  local config_overrides = {
    eslint = require 'lsp.language-servers.eslint',
    tsserver = require 'lsp.language-servers.tsserver',
    lua_ls = require 'lsp.language-servers.lua',
  }
  for _, language_server in pairs(servers) do
    local default_config = {
      on_attach = on_attach,
      capabilities = capabilities,
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
end
