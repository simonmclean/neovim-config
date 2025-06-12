return {
  'scalameta/nvim-metals',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  ft = { 'scala', 'sbt', 'java' },
  opts = function()
    local metals_config = require('metals').bare_config()

    metals_config.settings = {
      showImplicitArguments = true,
      showImplicitConversionsAndClasses = true,
      showInferredType = true,
      fallbackScalaVersion = '2.13.13',
      testUserInterface = 'Test Explorer',
      -- excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
    }

    metals_config.init_options.statusBarProvider = 'off'

    -- metals_config.on_attach = function(client, bufnr)
    --   lsp.on_attach(client, bufnr)
    -- end
    --
    -- metals_config.capabilities = lsp.capabilities

    return metals_config
  end,
  config = function(_, metals_config)
    -- Autocmd that will actually be in charge of starting the whole thing
    local nvim_metals_group = vim.api.nvim_create_augroup('nvim-metals', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
      -- NOTE: You may or may not want java included here. You will need it if you
      -- want basic Java support but it may also conflict if you are using
      -- something like nvim-jdtls which also works on a java filetype autocmd.
      pattern = { 'scala', 'sbt' },
      callback = function()
        require('metals').initialize_or_attach(metals_config)
      end,
      group = nvim_metals_group,
    })
  end,
}
