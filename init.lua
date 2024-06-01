local u = require 'utils'

vim.g.mapleader = ' '

IS_CWD_GIT_REPO = u.eval(function()
  local is_git_installed = type(vim.trim(vim.fn.system 'command -v git')) == 'string'
  if not is_git_installed then
    return false
  end
  return vim.trim(vim.fn.system 'git rev-parse --is-inside-work-tree') == 'true'
end)

require 'plugins'
