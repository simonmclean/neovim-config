local git = require 'git'

return {
  -- Git wrapper and lightweight UI
  'tpope/vim-fugitive',
  config = function()
    local autocmd_group = vim.api.nvim_create_augroup('FugitiveHooks', {})

    vim.api.nvim_create_autocmd('User', {
      pattern = { 'FugitiveChanged' },
      group = autocmd_group,
      callback = function()
        git.update_ahead_behind()
        git.update_current_branch()
      end,
    })

    local diffview_installed, _ = pcall(require, 'diffview')

      -- Hijack Fugitive's dv and dd commands and redirect them to Diffview
    if diffview_installed then
      local open_diffview = function()
        local line = vim.api.nvim_get_current_line()
        local path = string.sub(line, 3)
        vim.cmd('DiffviewOpen --selected-file=' .. path)
      end

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'fugitive' },
        group = autocmd_group,
        callback = function()
          local opts = { noremap = true, silent = true, buffer = true }
          vim.keymap.set('n', 'dv', open_diffview, opts)
          vim.keymap.set('n', 'dd', open_diffview, opts)
        end,
      })
    end
  end,
}
