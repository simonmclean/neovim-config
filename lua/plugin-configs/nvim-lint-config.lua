-- Linting plugin

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

    vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
