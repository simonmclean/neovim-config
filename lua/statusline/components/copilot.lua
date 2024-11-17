local icons = require "statusline.icons"

return function()
  return vim.g.copilot_enabled and icons.copilot_enabled or ''
end


