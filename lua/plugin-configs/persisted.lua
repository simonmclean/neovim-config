local utils = require 'utils'

local allowed_dirs = {
  '~/code',
  '~/.config/nvim'
}

local ignored_dirs = {
  'node_modules'
}

-- function Buffers_to_clear()
--   local tabs = vim.api.nvim_list_tabpages()
--   local windows = {}
--   local visible_buffers = {}
--   for t = 1, #tabs, 1 do
--     local tab_windows = vim.api.nvim_tabpage_list_wins(tabs[t])
--     for w = 1, #tab_windows, 1 do
--       table.insert(windows, tab_windows[w])
--     end
--   end
-- end

require("persisted").setup({
  autoload = true,
  allowed_dirs = allowed_dirs,
  ignored_dirs = ignored_dirs,
  telescope = {
    before_source = function()
      -- Save session before switching
      local current_dir = vim.fn.getcwd()
      local is_included = utils.dir_list_includes(current_dir, allowed_dirs)
      local is_ignored = utils.dir_list_includes(current_dir, ignored_dirs)
      if (is_included and not is_ignored) then
        require 'persisted'.save()
      end
      --  Close all buffers
      vim.cmd("silent bufdo bwipeout")
      -- Stop current LSPs
      vim.lsp.stop_client(vim.lsp.get_active_clients())
    end,
    after_source = function()
      -- Clear metals status line text
      vim.schedule(function() vim.g.metals_status = nil end)
    end
  },
})

require('telescope').load_extension('persisted')
