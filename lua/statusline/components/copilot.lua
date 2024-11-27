local icons = require "icons"

return function()
  return vim.g.copilot_enabled and icons.copilot_enabled or ''
end


