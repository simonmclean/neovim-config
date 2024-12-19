---@diagnostic disable: missing-fields
-- Advanced git diff UI

---@module 'lazy'
---@type LazyPluginSpec
return {
  'sindrets/diffview.nvim',
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
