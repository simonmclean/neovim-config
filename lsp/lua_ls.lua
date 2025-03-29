return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = {
    '.luarc.json',
    '.luarc.jsonc',
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
    'selene.yml',
    '.git',
  },
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
