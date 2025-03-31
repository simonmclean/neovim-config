return {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  dependencies = { 'rafamadriz/friendly-snippets' },
  version = '1.*',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    completion = { documentation = { auto_show = true } },
    signature = { enabled = true },
    cmdline = {
      completion = {
        menu = {
          auto_show = true
        }
      }
    }
  },
  opts_extend = { 'sources.default' },
}
