vim.o.shortmess = vim.o.shortmess:gsub('F', '') -- No idea what this means, but it's required apparently

local metals_config = require'metals'.bare_config

metals_config.settings = {
  javaHome = "/Library/Java/JavaVirtualMachines/jdk-11.0.11.jdk/Contents/Home"
}

metals_config.init_options.statusBarProvider = 'on'

metals_config.on_attach = require'lsp/lspconfig-config'.on_attach

local function init_metals()
  require'metals'.initialize_or_attach(metals_config)
end

vim.api.nvim_exec([[
  augroup metals_lsp
    au!
    au FileType scala,sbt lua require'plugin-configs/metals'.init_metals()
  augroup end
]], false)

return {
  init_metals = init_metals
}
