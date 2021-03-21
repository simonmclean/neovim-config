-- 1. get the config for this server from nvim-lspconfig and adjust the cmd path.
--    relative paths are allowed, lspinstall automatically adjusts the cmd and cmd_cwd for us!
local config = require'lspconfig'.diagnosticls.document_config
require'lspconfig/configs'.diagnosticls = nil -- important, unset the loaded config again
config.default_config.cmd[1] = "./node_modules/.bin/diagnostic-languageserver"

-- 2. extend the config with an install_script and (optionally) uninstall_script
require'lspinstall/servers'.diagnostic = vim.tbl_extend('error', config, {
  -- lspinstall will automatically create/delete the install directory for every server
  install_script = [[
  ! -f package.json && npm init -y --scope=lspinstall || true
  npm install diagnostic-languageserver
  ]],
  uninstall_script = 'npm uninstall diagnostic-languageserver'
})
