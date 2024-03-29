local util = require 'lspconfig/util'

return {
  root_dir = function(pattern)
    local cwd = vim.loop.cwd()
    local root = util.root_pattern('package.json', 'tsconfig.json', '.git')(pattern)
    return root or cwd
  end,
  on_attach_extend = function(client, bufnr)
    client.server_capabilities.document_formatting = false
  end,
}
