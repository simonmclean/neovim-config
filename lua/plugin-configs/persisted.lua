return function()
  local allowed_dirs = {
    '~/code',
    '~/.config/nvim',
  }

  local ignored_dirs = {
    'node_modules',
  }

  require('persisted').setup {
    autoload = true,
    allowed_dirs = allowed_dirs,
    ignored_dirs = ignored_dirs,
    branch_separator = '_',
  }

  require('telescope').load_extension 'persisted'
end
