local u = require 'utils'
local components = require 'statusline.components'

_G.StatusLine = function()
  return u.list_join({
    components.mode(),
    components.cwd(),
    components.branch(),
    components.git_ahead_behind(),
    components.diagnostics(false),
    components.push_right,
    components.datetime(),
  }, '  ')
end

vim.o.statusline = '%!v:lua.StatusLine()'

_G.Winbar = function()
  return u.list_join({
    components.push_right,
    components.win_title(true),
    components.cursor_pos(),
    components.diagnostics(true),
    components.readonly(),
    components.modified(),
    components.push_right,
  }, '  ')
end

vim.o.winbar = '%{%v:lua.Winbar()%}'
