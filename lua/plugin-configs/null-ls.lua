return {
  'jose-elias-alvarez/null-ls.nvim',
  event = 'VeryLazy',
  config = function()
    local null_ls = require 'null-ls'

    local code_actions = null_ls.builtins.code_actions
    local diagnostics = null_ls.builtins.diagnostics
    local fmt = null_ls.builtins.formatting

    null_ls.setup {
      sources = {
        -- eslint
        code_actions.eslint_d.with {
          -- Setting only_local to prevent error message when there's no local eslint config
          only_local = true,
        },
        diagnostics.eslint_d.with {
          only_local = true,
        },
        fmt.eslint_d.with {
          only_local = true,
        },

        -- prettier
        fmt.prettier.with {
          only_local = true,
        },

        -- clojure
        fmt.cljstyle,

        -- lua
        fmt.stylua.with {
          extra_args = { '--indent-type=Spaces', '--indent-width=2' },
        },
      },
    }
  end,
}
