local utils = require 'utils'

local allowed_dirs = {
  '~/code',
  '~/.config/nvim'
}

local ignored_dirs = {
  'node_modules'
}

require("persisted").setup({
  autoload = true,
  allowed_dirs = allowed_dirs,
  ignored_dirs = ignored_dirs,
  telescope = {
    before_source = function()
      local current_dir = vim.fn.getcwd()
      local is_included = utils.dir_list_includes(current_dir, allowed_dirs)
      local is_ignored = utils.dir_list_includes(current_dir, ignored_dirs)
      if (is_included and not is_ignored) then
        require 'persisted'.save()
      end
    end
  }
})

require('telescope').load_extension('persisted')
