-- Linting

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

    local eslint = lint.linters.eslint_d

    if eslint then
      eslint.args = {
        '--no-warn-ignored',
      }
    end

    vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter' }, {
      callback = function()
        local lsp_clients = vim.lsp.get_clients { bufnr = 0 }
        ---@type vim.lsp.Client[]
        local ts_ls = vim.tbl_filter(function(client)
          return client.name == 'ts_ls'
        end, lsp_clients)
        if #ts_ls > 0 then
          -- In the context of a typescript project, piggyback off the ts_ls root in order to run eslint from
          -- the correct directory. Without this it doesn't work properly in a monorepo because it doesn't
          -- resolve the eslint config correctly.
          lint.try_lint(nil, { cwd = ts_ls[1].root_dir })
        else
          lint.try_lint()
        end
      end,
    })
  end,
}
