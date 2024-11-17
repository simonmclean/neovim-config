return {
  settings = {
    Lua = {
      workspace = {
        ignoreDir = { '.luacheckrc' },
      },
      diagnostics = {
        disable = { '.luacheckrc' },
      },
      runtime = {
        version = 'LuaJIT',
      },
    },
  },
}
