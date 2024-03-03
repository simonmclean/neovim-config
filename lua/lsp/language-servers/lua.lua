return {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      format = {
        enable = false,
      },
      workspace = {
        checkThirdParty = false,
        library = {
          '${3rd}/luv/library',
          unpack(vim.api.nvim_get_runtime_file('', true)),
        },
      },
    },
  },
}
