return {
  'ggandor/leap.nvim',
  enabled = false,
  config = function()
    require('leap').add_default_mappings()
  end,
}
