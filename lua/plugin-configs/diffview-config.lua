---@diagnostic disable: missing-fields
-- Advanced git diff UI

-- Close diffview before exiting, otherwise it makes a mess when the session is restored
vim.api.nvim_create_autocmd('VimLeavePre', {
  callback = function()
    local diffview_installed, _ = pcall(require, 'diffview')
    if diffview_installed then
      local views = require('diffview.lib').views
      if #views > 0 then
        for _, view in ipairs(views) do
          view:close()
        end
      end
    end
  end,
})

---@module 'lazy'
---@type LazyPluginSpec
return {
  'sindrets/diffview.nvim',
  event = 'VeryLazy',
  ---@module 'diffview'
  ---@type DiffviewConfig
  opts = {
    enhanced_diff_hl = true,
    file_panel = {
      win_config = {
        position = 'top',
      },
    },
  },
}
