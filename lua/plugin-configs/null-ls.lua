return function()
  local null_ls = require "null-ls"

  null_ls.setup({
    sources = {
      -- eslint
      null_ls.builtins.code_actions.eslint_d.with({
        -- Setting only_local to prevent error message when there's no local eslint config
        only_local = true
      }),
      null_ls.builtins.diagnostics.eslint_d.with({
        only_local = true
      }),
      null_ls.builtins.formatting.eslint_d.with({
        only_local = true
      }),

      -- prettier
      null_ls.builtins.formatting.prettier.with({
        only_local = true
      }),

      -- clojure
      null_ls.builtins.formatting.cljstyle
    },
  })
end
