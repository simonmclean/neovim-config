vim.api.nvim_exec([[
  augroup metals_lsp
    au!
    au FileType scala,sbt lua require('metals').initialize_or_attach({})
  augroup end
]], false)

 local metals_config = require'metals'.bare_config
 metals_config.init_options.statusBarProvider = 'on'
