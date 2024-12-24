local u = require 'utils'
local config_path = vim.fn.stdpath 'config'

local function check()
  u.system(config_path .. '/check_version.sh', function(response)
    if response ~= 'Neovim is up to date' then
      vim.notify(response)
    end
  end)
end

-- Delayed to avoid the noise of startup
vim.defer_fn(check, 5000)
