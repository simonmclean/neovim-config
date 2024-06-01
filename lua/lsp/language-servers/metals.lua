return function(on_attach, capabilities)
  -- vim.opt_global.shortmess:remove("F")

  local metals_config = require('metals').bare_config()

  local api = vim.api

  metals_config.settings = {
    showImplicitArguments = true,
    showImplicitConversionsAndClasses = true,
    showInferredType = true,
    fallbackScalaVersion = '2.13.13',
    testUserInterface = 'Test Explorer',
    -- excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
  }

  metals_config.init_options.statusBarProvider = 'off'

  local dap = require 'dap'

  dap.configurations.scala = {
    {
      type = 'scala',
      request = 'launch',
      name = 'State loader',
      metals = {
        runType = 'run',
        port = 5005,
        host = 'localhost',
        jvmOptions = { '-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005' },
      },
    },
    {
      type = 'scala',
      request = 'launch',
      name = 'Run tests in file',
      metals = {
        runType = 'testFile',
      },
    },
    {
      type = 'scala',
      request = 'launch',
      name = 'Run tests in current build project',
      metals = {
        runType = 'testTarget',
      },
    },
  }

  metals_config.on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    require('metals').setup_dap()
  end
  metals_config.capabilities = capabilities

  -- Autocmd that will actually be in charging of starting the whole thing
  local nvim_metals_group = api.nvim_create_augroup('nvim-metals', { clear = true })
  api.nvim_create_autocmd('FileType', {
    -- NOTE: You may or may not want java included here. You will need it if you
    -- want basic Java support but it may also conflict if you are using
    -- something like nvim-jdtls which also works on a java filetype autocmd.
    pattern = { 'scala', 'sbt' },
    callback = function()
      require('metals').initialize_or_attach(metals_config)
    end,
    group = nvim_metals_group,
  })
end
