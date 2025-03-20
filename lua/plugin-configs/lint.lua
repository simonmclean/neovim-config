-- Linting plugin

-- A note on eslint: The js variable below previously contained { eslint_d }.
-- However it failed to parse the eslint configuration in a multi-project monorepo.
-- As such I've switched to using eslint-lsp
local js = { 'eslint_d' }

return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require 'lint'

    lint.linters_by_ft = {
      javascript = js,
      typescript = js,
      javascriptreact = js,
      typescriptreact = js,
      terraform = { 'tflint' },
      lua = { 'luacheck' },
    }

    vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter' }, {
      callback = function()
        local client = vim.lsp.get_clients({ bufnr = 0 })[1] or {}
        lint.try_lint(nil, { cwd = client.root_dir })
      end,
    })
  end,
}
