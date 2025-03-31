-- A sidebar with a tree-like outline of symbols from your code, powered by LSP.

-- https://github.com/hedyhli/outline.nvim/blob/main/lua/outline/symbols.lua
local icons = {
  Function = 'func',
  Class = 'class',
  Method = 'method',
  Property = 'prop',
  Constructor = 'constructor',
  Variable = 'var',
  Constant = 'const',
  String = 'str',
  Number = 'num',
  Boolean = 'bool',
  Array = 'arr',
  Object = 'obj',
}

local function icon_fetcher(kind)
  if icons[kind] then
    return icons[kind]
  end
  return string.lower(kind)
end

return {
  'hedyhli/outline.nvim',
  cmd = { 'Outline', 'OutlineOpen' },
  event = 'VeryLazy',
  keys = {
    -- Note: The exclamation mark means "open but don't focus"
    -- { '<leader>o', '<cmd>Outline!<CR>', desc = 'Toggle outline' },
  },
  opts = {
    preview_window = {
      auto_preview = true,
      winblend = vim.g.winblend,
    },
    outline_window = {
      -- These 2 options blend cursor with cursorline
      show_cursorline = true,
      hide_cursor = true,
    },
    symbols = {
      icon_fetcher = icon_fetcher
    },
  },
}
