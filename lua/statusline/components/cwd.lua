local icons = require 'statusline.icons'

return function()
  local path = vim.fn.getcwd()
  local dir = vim.fs.basename(path)
  return icons.dir .. ' ' .. dir
end
