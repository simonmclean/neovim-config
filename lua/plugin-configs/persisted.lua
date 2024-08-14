return {
  'olimorris/persisted.nvim',
  config = function()
    local utils = require 'utils'

    local allowed_dirs = {
      '~/code',
      '~/.config',
    }

    local ignored_dirs = {
      'node_modules',
    }

    require('persisted').setup {
      autoload = false,
      silent = true,
      allowed_dirs = allowed_dirs,
      ignored_dirs = ignored_dirs,
      branch_separator = '_',
    }

    local autocmd_group = vim.api.nvim_create_augroup('PersistedHooks', {})

    -- Exclude certain filetypes from the session
    vim.api.nvim_create_autocmd('User', {
      pattern = 'PersistedSavePre',
      group = autocmd_group,
      callback = function()
        local filetypes = { 'fugitive', 'Trouble', 'qf' }
        for _, bufid in ipairs(vim.api.nvim_list_bufs()) do
          local filetype = vim.api.nvim_buf_get_option(bufid, 'filetype')
          if utils.list_contains(filetypes, filetype) then
            vim.api.nvim_buf_delete(bufid, {})
          end
        end
      end,
    })

    local function restore_session()
      local persisted = require 'persisted'
      vim.schedule(function()
        persisted.load()
      end)
    end

    -- On startup check if lazy is auto-install mising plugins
    -- If it's not, load the session straight away
    -- If it is, subscribe to WinClosed and load session when lazy window is not longer visible
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      group = autocmd_group,
      callback = function()
        local lazy_view = require 'lazy.view'
        if not lazy_view.visible() then
          restore_session()
        else
          local win_closed_autocmd
          win_closed_autocmd = vim.api.nvim_create_autocmd('WinClosed', {
            pattern = '*',
            callback = function()
              if not lazy_view.visible() then
                vim.api.nvim_del_autocmd(win_closed_autocmd)
                restore_session()
              end
            end,
          })
        end
      end,
    })
  end,
}
